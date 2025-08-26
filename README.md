# bouncey-castle

Bouncey Castle is a tiny web service that "bounces" the content from another URL back to the requestor.

## Features
- Homepage explaining how to use the service
- `bounce_url` parameter fetches and returns remote content
- Optional `debug=1` parameter shows status, headers and the returned HTML in a toggleable view

## Local development
```bash
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
conda env create -f environment.yml
conda activate bouncey-castle
python app.py
```
Visit [http://localhost:8000](http://localhost:8000).

## Docker
```bash
docker build -t bouncey-castle .
docker run -p 8000:8000 bouncey-castle
```

## AWS deployment
1. Launch an EC2 instance with CloudFormation:
   ```bash
   aws cloudformation deploy \
     --template-file infra/cloudformation.yaml \
     --stack-name bouncey-castle \
     --capabilities CAPABILITY_IAM \
     --parameter-overrides KeyName=your-keypair
   ```
2. SSH to the instance and set `DOMAIN` then run `deploy.sh`:
   ```bash
   sudo DOMAIN=your.domain bash /opt/bouncey-castle/deploy.sh
   ```

## Route53 and certificates
1. In Route53 create a hosted zone for your domain.
2. Add an A record pointing to the EC2 instance public IP.
3. If using a registered domain elsewhere, update the registrar with Route53 name servers.
4. The deploy script installs Apache and uses Certbot to obtain a Let's Encrypt certificate which auto-renews via systemd timers.

## Apache configuration
The reverse proxy configuration is stored in `config/apache-bouncey-castle.conf` and routes HTTP/HTTPS traffic to the Gunicorn service running on port 8000.

## Infrastructure as Code
See `infra/cloudformation.yaml` for a reproducible AWS setup.

## Example
Bouncing a humorous image:
```
https://<your-domain>/?bounce_url=https://http.cat/418&debug=1
```
