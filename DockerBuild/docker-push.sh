#!/bin/bash

# Push base image
echo "🔹 Pushing theb0ys/base:latest"
docker push theb0ys/base:latest

# Push apache image
echo "🔹 Pushing theb0ys/apache:latest"
docker push theb0ys/apache:latest

# Push bind image
echo "🔹 Pushing theb0ys/bind:latest"
docker push theb0ys/bind:latest

# Push dns64 image
echo "🔹 Pushing theb0ys/dns64:latest"
docker push theb0ys/dns64:latest

# Push oldap image
echo "🔹 Pushing theb0ys/oldap:latest"
docker push theb0ys/oldap:latest

# Push mariadb image
echo "🔹 Pushing theb0ys/mariadb:latest"
docker push theb0ys/mariadb:latest

# Push nat64 image
echo "🔹 Pushing theb0ys/nat64:latest"
docker push theb0ys/nat64:latest

# Push nginx image
echo "🔹 Pushing theb0ys/nginx:latest"
docker push theb0ys/nginx:latest

# Push postfix-dovecot image
echo "🔹 Pushing theb0ys/postfix-dovecot:latest"
docker push theb0ys/postfix-dovecot:latest

# Push red-hornet image
echo "🔹 Pushing theb0ys/red-hornet:latest"
docker push theb0ys/red-hornet:latest

# Push rsyslog image
echo "🔹 Pushing theb0ys/ubuntu-desktop:latest"
docker push theb0ys/ubuntu-desktop:latest

# Push samba image
echo "🔹 Pushing theb0ys/samba:latest"
docker push theb0ys/samba:latest

# Push suricata image
echo "🔹 Pushing theb0ys/suricata:latest"
docker push theb0ys/suricata:latest

# Push ubuntu-desktop image
echo "🔹 Pushing theb0ys/ubuntu-desktop:latest"
docker push theb0ys/ubuntu-desktop:latest

echo "✅ All pushes completed!"
