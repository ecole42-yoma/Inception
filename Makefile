# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yongmkim <yongmkim@student.42seoul.kr>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/10/24 23:26:38 by yongmkim          #+#    #+#              #
#    Updated: 2022/10/31 18:08:43 by yongmkim         ###   ########seoul.kr   #
#                                                                              #
# **************************************************************************** #

NAME	=	Inception

DOCKER_COMPOSE	=	./srcs/docker-compose.yml
PATH_DOCKER_COMPOSE	=	./srcs

# check cluser env or vm env
ifeq ($(WHERE), cluster)
	SUDO		=	@
	PATH_DATA	=	~/projects/goinfre/yongmkim/data
else
	SUDO		=	@sudo
	PATH_DATA	=	/home/$(USER)/data
endif

.PHONY	:	all up  $(NAME) build make_dir
up		:	all
all		:	$(NAME) make_dir; 	$(SUDO) docker compose -f $(DOCKER_COMPOSE) up --force-recreate --build -d
build	: make_dir;				$(SUDO) docker compose -f $(DOCKER_COMPOSE) build
$(NAME)	:
# preprocess
make_dir:;	$(SUDO) mkdir -p $(PATH_DATA)/wordpress $(PATH_DATA)/db $(PATH_DATA)/bonus $(PATH_DATA)/tools

.PHONY	:	clean down
clean	:	down
down	:;						$(SUDO) docker compose -f $(DOCKER_COMPOSE) down

.PHONY	:	fclean
fclean	:	clean
	$(SUDO) docker system prune -af --volumes

.PHONY	:	db_flush db_clean db
db_flush:	db_clean
db		:	db_clean
db_clean:
	$(SUDO) rm -rf $(PATH_DATA)

.PHONY	:	re
re		:
	@make fclean
	@make all



.PHONY	:	stop pause
stop	:;	$(SUDO) docker compose -f $(DOCKER_COMPOSE) stop
pause	:;	$(SUDO) docker compose -f $(DOCKER_COMPOSE) pause

.PHONY	:	start unpause
start	:;	$(SUDO) docker compose -f $(DOCKER_COMPOSE) start
unpause	:;	$(SUDO) docker compose -f $(DOCKER_COMPOSE) unpause

.PHONY	:	top ps ls show s info
top		:;	$(SUDO) docker compose -f $(DOCKER_COMPOSE) top
ps		:;	$(SUDO) docker compose -f $(DOCKER_COMPOSE) ps
ls		:;	$(SUDO) docker compose ls
s		:	show
show	:
	@make ls
	@echo
	@make ps
	@echo
	@make top
info	:;	$(SUDO) docker info

.PHONY	:	l log logs
l		:	log
log		:	logs
logs	:;	$(SUDO) docker compose -f ./srcs/docker-compose.yml logs

.PHONY	:	v volumn volumes v-clean
v		:	volumes
volumes	:	volume
volume	:;	$(SUDO) docker volume ls
v-clean	:;	$(SUDO) docker volume rm $($(SUDO) docker volume ls | grep "inception")

.PHONY	:	exec curl enter into
into	:	exec
enter	:	exec
exec	:;	$(SUDO) docker exec -it $(c) /bin/sh
curl	:;	$(SUDO) curl localhost:$(p)

.PHONY	:	command c com
c		:	command
com		:	command
command	:
	@echo "--- make command list ---  "
	@echo "all, up, build"
	@echo "clean, down, fclean, re"
	@echo "stop, start"
	@echo "pause, unpause"
	@echo "top, ps, ls, show, info, log, volume"
	@echo "exec : exec c='container name'"
	@echo "curl : curl p='port number'"
