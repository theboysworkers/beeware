# Usa una imagen base de Debian
FROM theb0ys/base

# Actualiza el sistema e instala las dependencias necesarias
RUN apt-get update && \
    apt-get install -y build-essential libacl1-dev libattr1-dev \
    libgcrypt20-dev libtalloc-dev libldap2-dev libpam0g-dev liblzo2-dev \
    wget && \
    apt-get clean

# Descarga y descomprime Samba 3.0.20
RUN wget https://www.samba.org/pub/samba/old-releases/samba-3.0.20.tar.gz && \
    tar -xzf samba-3.0.20.tar.gz && \
    cd samba-3.0.20 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf samba-3.0.20.tar.gz samba-3.0.20
