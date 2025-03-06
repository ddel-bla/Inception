
NAME		= inception
SRCS		= ./srcs
COMPOSE		= $(SRCS)/docker-compose.yml
HOST_URL	= cfeliz-r.42.fr

all: up

up: 
	@mkdir -p ~/data/database
	@mkdir -p ~/data/wordpress_files
	@echo "127.0.0.1 $(HOST_URL)" | sudo tee -a /etc/hosts  && echo "$(HOST_ADD)"
	@docker-compose -p $(NAME) -f $(COMPOSE) up --build || (echo "$(FAIL)" && exit 1)
	@echo "$(UP)"

down:
	@docker-compose -p $(NAME) -f $(COMPOSE) stop
	@echo "$(DOWN)"

clean:
	@docker-compose -f $(COMPOSE) down -v
	@if [ -n "$$(docker ps -a --filter "name=nginx" -q)" ]; then docker rm -f nginx && echo "$(NX_CLN)"; fi
	@if [ -n "$$(docker ps -a --filter "name=wordpress" -q)" ]; then docker rm -f wordpress && echo "$(WP_CLN)"; fi
	@if [ -n "$$(docker ps -a --filter "name=mariadb" -q)" ]; then docker rm -f mariadb && echo "$(DB_CLN)"; fi

fclean: clean
	@sudo rm -rf ~/data
	@if [ -n "$$(docker image ls $(NAME)-nginx -q)" ]; then docker image rm -f $(NAME)-nginx && echo "$(NX_FLN)"; fi
	@if [ -n "$$(docker image ls $(NAME)-wordpress -q)" ]; then docker image rm -f $(NAME)-wordpress && echo "$(WP_FLN)"; fi
	@if [ -n "$$(docker image ls $(NAME)-mariadb -q)" ]; then docker image rm -f $(NAME)-mariadb && echo "$(DB_FLN)"; fi
	@sudo sed -i "/127.0.0.1 $(HOST_URL)/d" /etc/hosts && echo "$(HOST_RM)"
	@echo "eliminando volumenes y redes no usadas..."
	@docker system prune -a --volumes -f
	@echo "$(CACHE_CLEANED)"

status:
	@clear
	@echo "\nCONTAINERS\n"
	@docker ps -a
	@echo "\nIMAGES\n"
	@docker image ls
	@echo "\nVOLUMES\n"
	@docker volume ls
	@echo "\nNETWORKS\n"
	@docker network ls
	@echo ""


re: fclean all

test:
	@echo "\n🔍 Probando conexión a mariadb como root sin contraseña"
	@if docker exec -it mariadb mariadb -u root -e "SHOW DATABASES;" | grep -q "thedatabase"; then echo "✅ Conexión a mariadb como root exitosa."; else echo "❌ Error: No se pudo conectar a mariadb como root sin contraseña."; fi
	@echo "\n🔍 Probando conexión a mariadb como root con contraseña"
	@if docker exec -it mariadb mariadb -u root -p123 -e "SHOW DATABASES;" | grep -q "thedatabase"; then echo "✅ Conexión a mariadb como root con contraseña exitosa."; else echo "❌ Error: No se pudo conectar a mariadb como root con contraseña."; fi
	@echo "\n🔍 Probando conexión a mariadb como theuser sin contraseña"
	@if docker exec -it mariadb mariadb -u theuser -e "SHOW DATABASES;" | grep -q "thedatabase"; then echo "✅ Conexión a mariadb como theuser exitosa."; else echo "❌ Error: No se pudo conectar a mariadb como theuser sin contraseña."; fi
	@echo "\n🔍 Probando conexión con usuario y contraseña..."
	@if docker exec -it mariadb mariadb -u theuser -pabc -e "SHOW DATABASES;" | grep -q "thedatabase"; then echo "✅ Conexión con usuario y contraseña exitosa."; else echo "❌ Error: No se pudo conectar con usuario y contraseña."; fi




RED			= \033[0;31m
GREEN		= \033[0;32m
RESET		= \033[0m

MARK		= $(GREEN)✔$(RESET)
ADDED		= $(GREEN)Added$(RESET)
REMOVED		= $(GREEN)Removed$(RESET)
STARTED		= $(GREEN)Started$(RESET)
STOPPED		= $(GREEN)Stopped$(RESET)
CREATED		= $(GREEN)Created$(RESET)
EXECUTED	= $(GREEN)Executed$(RESET)

UP			= $(MARK) $(NAME) $(EXECUTED)
DOWN		= $(MARK) $(NAME) $(STOPPED)
FAIL		= $(RED)✖$(RESET) $(NAME) $(RED)Failed$(RESET)

HOST_ADD	= $(MARK) Host $(HOST_URL) $(ADDED)
HOST_RM		= $(MARK) Host $(HOST_URL) $(REMOVED)

NX_CLN		= $(MARK) Container nginx $(REMOVED)
WP_CLN		= $(MARK) Container wordpress $(REMOVED)
DB_CLN		= $(MARK) Container mariadb $(REMOVED)

NX_FLN		= $(MARK) Image $(NAME)-nginx $(REMOVED)
WP_FLN		= $(MARK) Image $(NAME)-wordpress $(REMOVED)
DB_FLN		= $(MARK) Image $(NAME)-mariadb $(REMOVED)

BKP			= $(MARK) Backup at $(HOME) $(CREATED)
CACHE_CLEANED = $(MARK) Docker cache and unused data $(REMOVED)

.PHONY: all up down clean fclean status re database