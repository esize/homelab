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

MARIADB_PASSWORD=$(<"/home/evan/homelab/secrets/mariadb/root_password.secret")

function user_exists() {
		local user=$1

		result=$(docker exec homelab-mariadb mariadb \
			-u$MARIADB_USER \
			-p$MARIADB_PASSWORD \
			-se "SELECT COUNT(*) FROM mysql.user WHERE user = '${user}'"
		)
		if [ "$result" = 1 ]; then  # DB exists
			echo "User '$database' already exists. Skipping..."
		else  # DB does not exist
				echo "User '${database}' does not exist. Creating user ${database}..."

				docker exec homelab-mariadb mariadb \
					-u$MARIADB_USER \
					-p$MARIADB_PASSWORD \
					-se "CREATE USER ${database} IDENTIFIED BY '${database}'"
                echo -e "Done!\n"
		fi
}


function database_exists() {
		local database=$1

		result=$(docker exec homelab-mariadb mariadb \
			-u$MARIADB_USER \
			-p$MARIADB_PASSWORD \
			-se "SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '${database}'"
		)

		if [ "$result" = 1 ]; then  # User exists
				echo "Database '$database' already exists. Skipping..."
		else  # User does not exist
				echo "Database '${database}' does not exist. Creating database ${database}..."

				docker exec homelab-mariadb mariadb \
					-u$MARIADB_USER \
					-p$MARIADB_PASSWORD \
					-se "CREATE DATABASE ${database}"
                echo -e "Done!\n"
		fi
}
		


# echo $(user_exists $dbname)
# database_exists $dbname
# echo $(database_exists $dbname)


function create_user_and_database() {
		local database=$1

		echo ""
		echo "Creating '$database' database"
		echo ""
		
		user_exists "$database"

		database_exists "$database"

		docker exec homelab-mariadb mariadb \
			-u$MARIADB_USER \
			-p$MARIADB_PASSWORD \
			-se "GRANT ALL PRIVILEGES ON ${database}.* TO '${database}' IDENTIFIED BY PASSWORD '${db}'"

		echo "Successful database creation '$database'"
		echo ""
}

create_user_and_database $dbname
