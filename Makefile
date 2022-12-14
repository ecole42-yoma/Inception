# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yongmkim <yongmkim@student.42seoul.kr>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/10/24 23:26:38 by yongmkim          #+#    #+#              #
#    Updated: 2022/11/10 02:07:57 by yongmkim         ###   ########seoul.kr   #
#                                                                              #
# **************************************************************************** #

NAME	=	Inception

DOCKER_COMPOSE	=	./srcs/docker-compose.yml
PATH_DOCKER_COMPOSE	=	./srcs

# check cluser env or vm env
ifeq ($(WHERE), cluster)
	SUDO		=	@
	PATH_DATA	=	~/projects/goinfre/yongmkim/data
	DOC			=	docker compose
else
	SUDO		=	@sudo
	PATH_DATA	=	/home/$(USER)/data
	DOC			=	docker-compose
endif

.PHONY	:	all up  $(NAME) build pre_process make_dir
up		:	$(NAME) make_dir; 	$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) up --build -d
all		:	$(NAME) make_dir; 	$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) up --force-recreate --build -d
build	:	pre_process;		$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) build
$(NAME)	:

# preprocess
# pre_process:	make_dir;		$(SUDO) cp -R ./srcs/requirements/tools/ $(PATH_DATA)/wordpress/
pre_process:
make_dir:;						$(SUDO) mkdir -p $(PATH_DATA)/wordpress $(PATH_DATA)/db $(PATH_DATA)/bonus $(PATH_DATA)/tools

.PHONY	:	clean down
clean	:	down
down	:;						$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) down

.PHONY	:	fclean
fclean	:	clean;				$(SUDO) docker system prune -af --volumes

.PHONY	:	db_flush db_clean db
db_flush:	db_clean
db		:	db_clean
db_clean:;						$(SUDO) rm -rf $(PATH_DATA)

.PHONY	:	re
re		:
	@make fclean
	@make all



.PHONY	:	stop pause
stop	:;	$(SUDO) docker compose -f $(DOCKER_COMPOSE) stop
pause	:;	$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) pause

.PHONY	:	start unpause
start	:;	$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) start
unpause	:;	$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) unpause

.PHONY	:	top ps ls show s info
top		:;	$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) top
ps		:;	$(SUDO) $(DOC) -f $(DOCKER_COMPOSE) ps
# ls		:;	$(SUDO) $(DOC) ls
s		:	show
show	:
	@make top
	@echo
	@make ps
info	:;	$(SUDO) docker info

.PHONY	:	l log logs
l		:	log
log		:	logs
logs	:;	$(SUDO) $(DOC) -f ./srcs/docker-compose.yml logs

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

# redis-cli enter, keys *
# wp redis status --path=$WORDPRESS_PATH

# need to add firewawll 20, 21 40000-40042 port

# sudo apt update
# sudo apt install git make
# sudo apt install docker.io
# echo "127.0.0.1	yongmkim.42.fr" >> /etc/hosts
