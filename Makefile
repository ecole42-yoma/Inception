# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yongmkim <yongmkim@student.42seoul.kr>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/10/24 23:26:38 by yongmkim          #+#    #+#              #
#    Updated: 2022/10/29 02:57:56 by yongmkim         ###   ########seoul.kr   #
#                                                                              #
# **************************************************************************** #

NAME	=	Inception

DOCKER_COMPOSE	=	./srcs/docker-compose.yml
PATH_DOCKER_COMPOSE	=	./srcs

# check cluser env or vm env
ifeq ($(WHERE), cluster)
	SUDO	=
	PATH_DATA	=	~/project/goinfre/$(USER)/data
else
	SUDO	=	@sudo
	PATH_DATA	=	/home/$(USER)/data
endif

.PHONY	:	all	up	docker_install $(NAME)
up		:	all
all		:	$(NAME)	|	make_dir
	$(SUDO) docker compose -f $(DOCKER_COMPOSE) up --force-recreate --build -d

#docker_install:
# find docker and docker-compose if not install it

$(NAME)	:
# preprocess

make_dir:
	$(SUDO) mkdir -p $(PATH_DATA)/wordpress $(PATH_DATA)/db $(PATH_DATA)/bonus $(PATH_DATA)/tools


.PHONY	:	clean down
clean	:	down
down	:
	$(SUDO) docker compose -f $(DOCKER_COMPOSE) down


.PHONY	:	fclean
fclean	:	clean
	$(SUDO) rm -rf $(PATH_DATA)
	$(SUDO) docker system prune -af --volumes


.PHONY	:	re
re		:
	@make fclean
	@make all


.PHONY	:	stop pause
stop	:
	$(SUDO) docker compose -f $(DOCKER_COMPOSE) stop
pause	:
	$(SUDO) docker compose -f $(DOCKER_COMPOSE) pause


.PHONY	:	start unpause
start	:
	$(SUDO) docker compose -f $(DOCKER_COMPOSE) start
unpause	:
	$(SUDO) docker compose -f $(DOCKER_COMPOSE) unpause

.PHONY	:	top ps ls info show log logs s
top		:
	$(SUDO) docker compose -f $(DOCKER_COMPOSE) top

ps		:
	$(SUDO) docker compose -f $(DOCKER_COMPOSE) ps

ls		:
	$(SUDO) docker compose ls

s		:	show
show	:
	@make ls
	@echo
	@make ps
	@echo
	@make top

info	:
	$(SUDO) docker info
log		:	logs
logs	:
	@cd srcs && $(SUDO) docker compose logs

.PHONY	:	command c com
c		:	command
com		:	command
command	:
	@echo "--- make command list ---  "
	@echo "all, up"
	@echo "clean, down, fclean, re"
	@echo "stop, start"
	@echo "pause, unpause"
	@echo "top, ps, ls, show, info"
	@echo "exec : exec c='container name'"
	@echo "curl : curl p='port number'"

.PHONY	:	exec curl enter into
into	:	exec
enter	:	exec
exec	:
	$(SUDO) docker exec -it $(c) /bin/sh

curl	:
	$(SUDO) curl localhost:$(p)
