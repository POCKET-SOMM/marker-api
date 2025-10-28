FROM nvidia/cuda:12.4.1-base-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# COPY ALL source code first
# This includes pyproject.toml, README.md, server.py,
# and (most importantly) the 'marker_api' directory.
COPY . .

# NOW, run the install.
# pip will find pyproject.toml and the 'marker_api' directory
# and the install will succeed.
RUN pip3 install -e .

ENV ENV=production

EXPOSE 8080

CMD ["python3", "server.py"]
