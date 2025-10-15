FROM theb0ys/base:latest

# Install samba
RUN apt-get update && \
    apt-get install -y samba && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*