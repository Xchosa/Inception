mariaDb_Dir = /home/poverbec/data/mariadb
wordpress_Dir = /home/poverbec/data/wordpress



up: sync-time
	@mkdir -p $(mariaDb_Dir) $(wordpress_Dir)
	bash ./create_default_env.sh
	bash ./create_default_secrets.sh
#	sudo cp /etc/hosts /etc/hosts.backup
	sudo cp script/hosts /etc/hosts 
	cd src && docker compose -f docker-compose.yml  up --build


debug-wordpress:
	docker run -it wordpress /bin/bash
#innerhalb vom container befehle runnen 
# -> container stopped nicht direkt/ heangt sich auf 

debug-mariaDb:
	docker run -it mariadb /bin/bash


debug-nginx: 
	docker run -it nginx /bin/bash
#debug-wordpress-running:
#    docker compose exec wordpress /bin/bash

#docker container ls -a 
down:
	cd src && docker compose down
# see all running containers

#docker rm [id]
backup:
	@mkdir -p ../backup/wordpress_backup
	cd src && docker-compose exec wordpress wp db export /var/www/html/backup.sql --allow-root --path=/var/www/html
	cd src && docker cp wordpress:/var/www/html/backup.sql ../../backup/backup.sql
	cd src && docker-compose exec wordpress rm /var/www/html/backup.sql
	cd src && docker cp wordpress:/var/www/html/wp-content ../../backup/wordpress_backup/


sync-time:
	sudo timedatectl set-ntp on
	sudo timedatectl status

clean:
	cd src && docker compose down -v
	docker system prune -af
#	docker system prune -af --volume

fclean:
#	@sudo chown -R $(USER):$(USER) $(mariaDb_Dir) $(wordpress_Dir) 2>/dev/null || true
	@sudo chown -R $(USER):$(USER) $(mariaDb_Dir) $(wordpress_Dir) || true
	@rm -rf $(mariaDb_Dir) $(wordpress_Dir) $(SSL_DIR)
	make clean

re: clean up


.PHONY: up down debug-wordpress clean re sync-time