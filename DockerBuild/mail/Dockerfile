FROM theb0ys/base

# Install postfix and dovecot
RUN apt update && \
    apt install -y --no-install-recommends \
        postfix \
        dovecot-imapd && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*