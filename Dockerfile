FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN curl -sSLo /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh
ENV PATH="/opt/conda/bin:${PATH}"

COPY environment.yml /tmp/environment.yml
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    conda env create -f /tmp/environment.yml
ENV PATH="/opt/conda/envs/bouncey-castle/bin:${PATH}"

WORKDIR /app
COPY . /app
EXPOSE 8000

CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
