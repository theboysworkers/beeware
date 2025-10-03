FROM theb0ys/base:latest

# Install TAYGA (NAT64 gateway) and nginx-extras (for vnc 5900)
RUN apt-get update && \
    apt-get install -y tayga nginx nginx-extras && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*