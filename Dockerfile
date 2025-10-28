FROM nvidia/cuda:12.4.1-base-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

ENV ENV=production

EXPOSE 8080

CMD ["python3", "server.py"]
