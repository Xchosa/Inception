mariaDb_Dir = /home/poverbec/data/mariadb
wordpress_Dir = /home/poverbec/data/wordpress

all: up 

up:
	@mkdir -p $(mariaDb_Dir) $(wordpress_Dir)
	sudo cp script/hosts /etc/hosts 
	cd src && docker compose -f docker-compose.yml  up -d --build

setup:
	bash ./script/create_default_env.sh
	bash ./script/create_default_secrets.sh
	bash ./script/create_hosts.sh

down:
	cd src && docker compose down

sync-time:
	sudo timedatectl set-ntp on
	sudo timedatectl status
	sudo systemctl restart docker

clean:
	cd src && docker compose down -v
	docker system prune -af

fclean:
	@sudo chown -R $(USER):$(USER) $(mariaDb_Dir) $(wordpress_Dir) || true
	@rm -rf $(mariaDb_Dir) $(wordpress_Dir) $(SSL_DIR)
	make clean

re: clean up


.PHONY: up down debug-wordpress clean re sync-time