FROM theb0ys/base:latest

LABEL description="This is an image for a DNS server with BIND."

# Install BIND and DNS tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bind9 \
        bind9utils \
        bind9-dnsutils \
        dnsutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*