docker stop $(docker ps -aq)
docker rm -vf $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker volume prune -f
docker network prune -f
