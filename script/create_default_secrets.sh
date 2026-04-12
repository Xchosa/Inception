#!/bin/bash

set -e 

# load config
#source ./config.env

secrets="./secrets"

#only check if directory secrets is existing
if [ ! -d $secrets ]; then 
    echo "secrets directory is missing"
    while true; do
        read -p "Do you want to create a default secret directory with default creditentials?, Type YES" UserInput

        if [ "$UserInput" = "YES" ]; then 

            mkdir -p "$secrets/ssl"

            openssl req -x509 -nodes -days 365 \
            -newkey rsa:2048 \
            -keyout "$secrets/ssl/privKey.pem" \
            -out "$secrets/ssl/certificate.pem" \
            -subj "/CN=localhost"

            # Create secret files
            echo "halloSQL" > "$secrets/wp_user_password.txt"
            echo "superPaul" > "$secrets/wp_admin_password.txt"
            echo "secureFTP" > "$secrets/sftp_password.txt"
            echo "sqlUser01" > "$secrets/db_user_password.txt"
            echo "superSqlUser" > "$secrets/db_root_password.txt"

            echo "Secrets directory created."
            break

        elif [ "$UserInput" = "NO" ]; then
            echo "No directory created."
            break 
        else
            echo "invalid input. Please type YES or NO"
        fi
    done

else
    echo "secrets directory set up. Content has not been checked!"
fi