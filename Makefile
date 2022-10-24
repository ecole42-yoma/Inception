# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yongmkim <codeyoma@gmail.com>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/10/24 23:26:38 by yongmkim          #+#    #+#              #
#    Updated: 2022/10/25 00:03:04 by yongmkim         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME	=	Inception

PATH_DATA	=	/home/yongmkim/data
DOCKER_COMPOSE	=	/srcs/docker-compose.yml



.PHONY	:	all	up	docker_install
up		:	all
all		:	$(NAME) | docker_install make_dir
	sudo docker-compose -f $(DOCKER_COMPOSE) -p $(NAME) --force-recreate --build -d


docker_install:
	# find docker and docker-compose if not install it


$(NAME)	:	

make_dir:
	sudo mkdir -p $(PATH_DATA)/wordpress $(PATH_DATA)/mariadb $(PATH_DATA)/bonus $(PATH_DATA)/tools

.PHONY	:	clean down
down	:	clean
claen	:


.PHONY	:	fclean
fclean	:	clean
	sudo rm -rf $(PATH_DATA)
	sudo docker system prune -af --volumes


.PHONY	:	re
re		:
	make fclean
	make all


.PHONY	:	stop pause
stop	:
pause	:


.PHONY	:	start unpause
start	:
unpause	:


.PHONY	:	top ps
top		:

ps		:
