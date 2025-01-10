up:
    docker compose -f compose.yml --profile all up -d --remove-orphans

pull:
    docker compose -f compose.yml --profile all pull

down:
    docker compose -f compose.yml --profile all down

restart:
    docker compose -f compose.yml --profile all down
    docker compose -f compose.yml --profile all up -d

logs container *FLAGS:
    docker compose -f compose.yml logs {{container}} {{FLAGS}}

alias log := logs

r:
    git pull
    just up

down-v:
    docker compose -f compose.yml --profile all down -v

db name engine='postgres':
    ./scripts/create-{{engine}}-db.sh {{name}}

[confirm]
rm:
    docker compose -f compose.yml --profile all down -v
    sudo rm -rf ./appdata
    
forced:
    just rm
    just up