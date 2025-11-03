FROM theb0ys/base:latest

LABEL description="This is an image for a Samba Server with SAMBA."

# Install samba
RUN apt-get update && \
    apt-get install -y samba && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*