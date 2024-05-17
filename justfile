up:
    docker compose -f compose.yml --profile all up -d --remove-orphans

down:
    docker compose -f compose.yml --profile all down

restart:
    docker compose -f compose.yml --profile all down
    docker compose -f compose.yml --profile all up -d

logs container *FLAGS:
    docker compose -f compose.yml logs {{container}} {{FLAGS}}

alias log := logs

down-v:
    docker compose -f compose.yml --profile all down -v

db name engine='postgres':
    ./scripts/create-{{engine}}-db.sh {{name}}

[confirm]
rm:
    docker compose -f compose.yml --profile all down -v
    sudo rm -rf ./appdata
    mkdir -p appdata/traefik/acme
    sudo touch appdata/traefik/acme/acme.json
    sudo chmod 600 appdata/traefik/acme/acme.json
    
forced:
    just rm
    just up