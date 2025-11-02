# Base image
FROM theb0ys/base:latest

RUN apt-get update && apt-get install -y \
    openvpn \
    easy-rsa \
    && apt-get clean && rm -rf /var/lib/apt/lists/*