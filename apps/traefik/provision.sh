#!/bin/sh

# make sure the the json file to store certificates exists and has the correct access rights
mkdir -p /certificates
touch /certificates/acme.json
chmod 600 /certificates/acme.json

# copy configuration template and replace variables
cp /traefik.template.yml /etc/traefik/traefik.yml
sed -i "s|\${DOMAIN_NAME}|$(printf '%s\n' "$DOMAIN_NAME" | sed 's/[&/\]/\\&/g')|" /etc/traefik/traefik.yml
sed -i "s|\${ADMIN_EMAIL}|$(printf '%s\n' "$ADMIN_EMAIL" | sed 's/[&/\]/\\&/g')|" /etc/traefik/traefik.yml
sed -i "s|\${LETS_ENCRYPT_ENV}|$(printf '%s\n' "$LETS_ENCRYPT_ENV" | sed 's/[&/\]/\\&/g')|" /etc/traefik/traefik.yml
