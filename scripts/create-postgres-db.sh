#!/bin/bash

set -e
set +u

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; cd ..; pwd -P )
source "$parent_path/.env"

if [ $# -ge 1 ] && [ -n "$1" ]
then
    dbname=$1
else
    read -p "Database name: " dbname
fi



POSTGRES_PASSWORD=$(<"$parent_path/secrets/postgres/pg_root_password.secret")

function user_exists() {
		local user=$1

		result=$(docker exec homelab-postgres psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_roles WHERE rolname = '${user}'" 'postgres')

		if [ -z "$result" ]; then
				return 1
		else
				return 0
		fi
}

function database_exists() {
		local database=$1

		result=$(docker exec homelab-postgres psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_database WHERE datname = '${database}'" postgres)

		if [ -z "$result" ]; then
				return 1
		else
				return 0
		fi
}

function create_user_and_database() {
		local database=$1

		echo ""
		echo "Creating '$database' database"
		echo ""

		if user_exists "$database"; then
				echo "User '$database' already exists. Skipping..."
		else
				echo "User '${database}' does not exist. Creating user ${database}..."

				docker exec homelab-postgres psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" <<-EOSQL
					CREATE USER $database WITH PASSWORD '$POSTGRES_PASSWORD';
				EOSQL
                echo -e "Done!\n"
		fi

		if database_exists "$database"; then
				echo "Database '$database' already exists. Skipping..."
		else
				echo "Database '${database}' does not exist. Creating database ${database}..."

				docker exec homelab-postgres psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" <<-EOSQL
						CREATE DATABASE $database;
				EOSQL
                echo -e "Done!\n"
		fi

		docker exec homelab-postgres psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" <<-EOSQL
			GRANT SET ON PARAMETER session_replication_role TO $database;
			ALTER DATABASE $database OWNER TO $database;
		EOSQL

		echo "Successful database creation '$database'"
		echo ""
}

create_user_and_database $dbname
