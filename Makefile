mariaDb_Dir = /home/poverbec/data/mariadb
wordpress_Dir = /home/poverbec/data/wordpress



up: 
	@mkdir -p $(mariaDb_Dir) $(wordpress_Dir)
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
# see all running containers

#docker rm [id]

clean:
	cd src && docker compose down -v
	docker system prune -af

fclean:
	@rm -rf $(mariaDb_Dir) $(wordpress_Dir)
	make clean

re: clean up


.PHONY: up down debug-wordpress clean re