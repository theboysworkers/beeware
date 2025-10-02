FROM theb0ys/base:latest

# Install mariadb apache and php dependeces
RUN apt update && \
    apt install -y --no-install-recommends \
        apache2 \
        php \
        libapache2-mod-php \
        php-mysql \
        php-curl \
        php-xml \
        php-mbstring \
        php-intl \
        php-zip \
        php-json \
        php-pear \
        php-bz2 \
        php-gmp \
        php-imap \
        php-imagick \
        mariadb-server \
        wget \
        unzip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
