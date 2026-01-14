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
