SHELL = /bin/sh

# show this help
help:
	@awk '/^#/{c=substr($$0,3);next}c&&/^[[:alpha:]][[:alnum:]_-]+:/{print substr($$1,1,index($$1,":")),c}1{c=0}' $(MAKEFILE_LIST) | column -s: -t


# start the application
up:
	docker-compose up

# stop and remove artifacts of the application
down:
	docker-compose down --remove-orphans

# create docker images
images:
	docker-compose build --force-rm

# create docker images with pull
images-pull:
	docker-compose build --force-rm --pull

# open a bash CLI in the application container
bash:
	docker-compose run --rm app ash