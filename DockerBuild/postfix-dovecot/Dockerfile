FROM theb0ys/base

LABEL description="This is an image for a Mail Server with POSTFIX and DOVECOT."

# Install postfix and dovecot
RUN apt update && \
    apt install -y --no-install-recommends \
        postfix \
        dovecot-imapd && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*