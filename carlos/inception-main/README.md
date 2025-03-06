docker stop $(docker ps -qa); docker rm $(docker ps -qa);
docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q);
https://projects.intra.42.fr/scale_teams/3929979/edit
2/72/16/22, 6:12 PM
Intra Projects Inception Edit
docker network rm $(docker network ls -q) 2>/dev/null
