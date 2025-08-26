import logging

import requests
from flask import Flask, Response, render_template, request

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)


def is_truthy(value: str) -> bool:
    return value.lower() in {"true", "1"}


@app.route("/")
def index():
    target_url = request.args.get("bounce_url")
    debug = request.args.get("debug", "false")
    if not target_url:
        return render_template("index.html")

    headers = {}
    body = ""
    status_code = 200
    error = None

    try:
        resp = requests.get(target_url, timeout=10)
        headers = dict(resp.headers)
        body = resp.content
        status_code = resp.status_code
    except Exception as exc:  # pragma: no cover - network issues
        error = str(exc)
        status_code = 500

    if is_truthy(debug):
        return render_template(
            "debug.html",
            target_url=target_url,
            status_code=status_code,
            headers=headers,
            error=error,
            body=body.decode("utf-8", errors="replace"),
        )

    resp_headers = {key: value for key, value in headers.items() if key.lower() != "content-length"}
    return Response(body, status=status_code, headers=resp_headers)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
