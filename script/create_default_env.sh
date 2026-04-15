#!/bin/bash

set -e

ENV_FILE="./src/.env"

if [ ! -f $ENV_FILE ]; then 
	echo "No .env file found."


	while true; do
		read -p "Do you want to create a default env? if yes, type <YES>. To exit the loop type <NO>." UserAnswer
		if [ "$UserAnswer" = "YES" ]; then


			cat <<EOF > "$ENV_FILE"
MYSQL_DATABASE=mydb
MYSQL_USER=paul

DOMAIN_NAME=poverbec.42.fr

#WordPress
WP_ADMIN_USER=SuperUser
WP_ADMIN_EMAIL=super@example.com

WP_USER=paul
WP_USER_EMAIL=paul.overbeck95@gmail.com


WP_DB_PREFIX=wp_
MYSQL_HOST=mariadb

FTP_USER=paulFTP



EOF

			echo ".env file created at $ENV_FILE"
			break
				
		elif [ "$UserAnswer" = "NO" ]; then
			echo "no .env created"
			break
		else
			echo "Invalid input, please type YES or NO."
		fi
	done


else
	echo ".env file already exists."
fi



