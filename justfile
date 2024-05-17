up:
    docker compose -f compose.yml --profile all up -d

down:
    docker compose -f compose.yml --profile all down

down-v:
    docker compose -f compose.yml --profile all down -v

create-postgres-db:
    ./scripts/create-postgres-db.sh