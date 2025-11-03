FROM theb0ys/base:latest

LABEL description="This is an image for a Web Server with Nginx, PHP-fpm."

# Install nginx and PHP with common modules
RUN apt-get update && \
    apt-get install -y nginx php8.2-fpm php-mysql php-xml php-mbstring php-curl php-zip php-gd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
