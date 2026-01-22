Developer documentation



* Set up the environment from scratch (prerequisites, configuration files, secrets).
* Build and launch the project using the Makefile and Docker Compose.
  * make up 	-> building up
* Use relevant commands to manage the containers and volumes.
  * docker ps
  * docker stop
  * Delete all containers

    * docker rm $(docker ps- ag) -f
  * delete all containers

    * Docker rmi($docker images -q)
* Identify where the project data is stored and how it persists


check if wordpress works:
Curl -lk https://poverbec.42.fr

check for self signed certificate 
curl --head https://poverbec.42.fr 


Execute mariadb setup
Docker exec -t mariadb sh 

entere Database as root user 
mysql -u root -p$(cat /run/secrets/db_root_password)

https::/poverbec.42.fr//wp-admin