
.PHONY: up down debug-wordpress clean re


up: 
	src/docker compose up --build


debug-wordpress:
	docker run -it wordpress /bin/bash
#innerhalb vom container befehle runnen 
# -> container stopped nicht direkt/ heangt sich auf 

#debug-wordpress-running:
#    docker compose exec wordpress /bin/bash

#docker container ls -a 
# see all running containers

#docker rm [id]

clean:
	docker compose down -v
	docker system prune -af

re: clean up