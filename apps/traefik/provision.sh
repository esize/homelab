#!/bin/sh

# make sure the the json file to store certificates exists and has the correct access rights
mkdir -p /certificates
touch /certificates/acme.json
chmod 600 /certificates/acme.json

# copy configuration template and replace variables
cp /traefik.template.yml /etc/traefik/traefik.yml
sed -i "s/\${DOMAIN_NAME}/$DOMAIN_NAME/" /etc/traefik/traefik.yml
sed -i "s/\${ADMIN_EMAIL}/$ADMIN_EMAIL/" /etc/traefik/traefik.yml

LE_ENV="${LETS_ENCRYPT_ENV:-https://acme-v02.api.letsencrypt.org/directory}"
sed -i "s/\${LE_ENV}/$LE_ENV/" /etc/traefik/traefik.yml
