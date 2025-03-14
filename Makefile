all: setup
	docker-compose -f ./srcs/docker-compose.yml up -d --build

setup:
	mkdir -p /home/ddel-bla/data/mariadb
	mkdir -p /home/ddel-bla/data/wordpress
	sudo chmod -R 777 /home/ddel-bla/data/mariadb
	sudo chmod -R 777 /home/ddel-bla/data/wordpress
down:
	docker-compose -f ./srcs/docker-compose.yml down

re: down clean all

clean:
	docker stop $$(docker ps -q) 2>/dev/null || true; \
	docker rm $$(docker ps -qa) 2>/dev/null || true; \
	docker rmi -f $$(docker images -qa) 2>/dev/null || true; \
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true; \
	docker network rm $$(docker network ls -q | grep -v "bridge\|host\|none") 2>/dev/null || true;

fclean: clean
	docker system prune -f
	sudo rm -rf /home/ddel-bla/data/mariadb/*
	sudo rm -rf /home/ddel-bla/data/wordpress/*

logs-maria: 
	docker logs -f srcs-mariadb-1
logs-wordpress: 
	docker logs -f srcs-wordpress-1
logs-nginx: 
	docker logs -f srcs-nginx-1

.PHONY: all re down clean setup
