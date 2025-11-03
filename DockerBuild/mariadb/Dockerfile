FROM theb0ys/base:latest

LABEL description="This is an image for a SQL server with MariaDB."

# Install MariaDB
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		    mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*