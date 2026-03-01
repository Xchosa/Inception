Developer documentation



Set up the environment from scratch (prerequisites, configuration files, secrets).
  generate a secrets/sftpSSL directory and a secrets/ssl directory to store the selfsigned certtificat and key with openssl 

  e.g. with openssl genrsa -des3 -out ca.key 2048

  for sftpSSL 
    ftp-cert.pem
    ftp-key.pem
  for ssl
    certificate.pem
    privKey.pem

for using the FTP server
needed dependencies
sudo apt install lftp

lftp -u <FTP_USER_env> localhost:21

<FTP_USER_PASS_secrets>
upload via "put"
e.g. put /home/<user>/<UserDance.mp4> 
ls 
quit or 

(for connecting to VM Filedirectory
 => sftp://<VM_USER>@localhost/ )

check pwd or ls -la

cd wp-content/uploads
e.g. https://poverbec.42.fr/wp-content/uploads/test.txt


Build and launch the project using the Makefile and Docker Compose.
  * make up 	-> building up
  * every other command descriped in Makefile 
  make clean
      wipes out almoust all unused Docker data, reclaim disk space 
      does docker system prune 
        (removes all sopeed containers, unused networks, unsued buid cache )
      includes the -af flag
        images needs to bee repulled
        does not delete the volumes 
  * make fclean -> delete all containers


Use relevant commands to manage the containers and volumes.
  * docker ps
  * docker down - delelte volumes
  * docker stop
  * Delete all containers

  * docker rm $(docker ps- ag) -f
  * delete all containers

   * Docker rmi($docker images -q)

Check if specific Container is running:
e.g. FTP server
  docker ps | grep ftp

Stop one specific Container 
docker stop ftp_server

Check if vsftpd process is running
docker exec ftp_server ps aux | grep vsftpd


Identify where the project data is stored and how it persists


check if wordpress works:
Curl -lk https://poverbec.42.fr

check for self signed certificate 
curl --head https://poverbec.42.fr 


Execute mariadb setup
Docker exec -t mariadb sh 

entere Database as root user 
mysql -u root -p$(cat /run/secrets/db_root_password)

https::/poverbec.42.fr//wp-admin

Build a single container:
docker compose up --build wordpress

