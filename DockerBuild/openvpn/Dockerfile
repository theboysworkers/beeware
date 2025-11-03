FROM theb0ys/base:latest

LABEL description="This is an image for a VPN Server with OpenVPN."

RUN apt-get update && apt-get install -y \
    openvpn \
    easy-rsa \
    && apt-get clean && rm -rf /var/lib/apt/lists/*