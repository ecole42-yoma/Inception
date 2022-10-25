# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yongmkim <codeyoma@gmail.com>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/10/24 23:26:38 by yongmkim          #+#    #+#              #
#    Updated: 2022/10/25 16:33:16 by yongmkim         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME	=	Inception

PATH_DATA	=	~/projects/goinfre/$(USER)/data
DOCKER_COMPOSE	=	./srcs/docker-compose.yml
PATH_DOCKER_COMPOSE = ./srcs



.PHONY	:	all	up	docker_install
up		:	all
all		:	$(NAME) | make_dir
	@sudo docker compose -f $(DOCKER_COMPOSE) up --force-recreate --build -d


#docker_install:
	# find docker and docker-compose if not install it

$(NAME)	:	
	# preprocess

make_dir:
	@sudo mkdir -p $(PATH_DATA)/wordpress $(PATH_DATA)/mariadb $(PATH_DATA)/bonus $(PATH_DATA)/tools

.PHONY	:	clean down
clean	:	down
down	:
	@sudo docker compose -f $(DOCKER_COMPOSE) down 



.PHONY	:	fclean
fclean	:	clean
	@sudo rm -rf $(PATH_DATA)
	@sudo docker system prune -af --volumes

.PHONY	:	re
re		:
	@make fclean
	@make all



.PHONY	:	stop pause
stop	:
	@sudo docker compose -f $(DOCKER_COMPOSE) stop
pause	:
	@sudo docker compose -f $(DOCKER_COMPOSE) pause


.PHONY	:	start unpause
start	:
	@sudo docker compose -f $(DOCKER_COMPOSE) start
unpause	:
	@sudo docker compose -f $(DOCKER_COMPOSE) unpause


.PHONY	:	top ps ls show info
top		:
	@sudo docker compose -f $(DOCKER_COMPOSE) top

ps		:
	@sudo docker compose -f $(DOCKER_COMPOSE) ps

ls		:
	@sudo docker compose ls

info	:
	@sudo docker info


.PHONY	: command c com
c	: command
com	: command
command	:
	@echo "--- make command list ---  "
	@echo "all, up"
	@echo "clean, down, fclean, re"
	@echo "stop, start"
	@echo "pause, unpause"
	@echo "top, ps , ls"
