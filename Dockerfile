FROM nvidia/cuda:12.4.1-base-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libgl1-mesa-glx
RUN apt-get update && apt-get install -y libglib2.0-0

WORKDIR /app

# COPY ALL source code first
# This includes pyproject.toml, README.md, server.py,
# and (most importantly) the 'marker_api' directory.
COPY . .

# NOW, run the install.
# pip will find pyproject.toml and the 'marker_api' directory
# and the install will succeed.

ENV PYTHONUNBUFFERED=1
COPY --from=ghcr.io/astral-sh/uv:0.8.4 /uv /uvx /bin/
ENV PATH="/app/.venv/bin:$PATH"

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV ACCEPT_EULA=Y
ENV PATH=/usr/local/bin:$PATH

ENV PYTHONPATH=/app

# RUN pip3 install -e .
RUN uv venv
RUN uv pip install -e .
RUN uv pip install torch surya-ocr
RUN uv pip install transformers==4.45.2

ENV ENV=production

EXPOSE 8080

CMD ["python3", "server.py"]
