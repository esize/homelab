up:
    docker compose -f compose.yml --profile all up -d

down:
    docker compose -f compose.yml --profile all down

down-v:
    docker compose -f compose.yml --profile all down -v

db name engine='postgres':
    ./scripts/create-{{engine}}-db.sh {{name}}