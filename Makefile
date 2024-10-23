SHELL = /bin/sh

# This Makefile includes a `make help` feature that allows to list existing commands
# Do not forget to add a description, as comment, before each command.

# standard
.PHONY: install installdirs uninstall dist clean cleandist

# prepare the application to be run for the first time
install: installdirs configure images

# create directories required for installation
installdirs:
	mkdir -p data
	mkdir -p dist
	mkdir -p mysql/data
	mkdir -p app/content

# turn off the application, clean the database and remove the configuration
uninstall: clean cleandist rmenvs rmdirs

# generate staticfiles
dist: cleandist
	# Ask app to collect staticfiles


	# Clean and copy staticfiles to nginx folder
	mkdir -p dist
	#cp -rv app/staticfiles/* staticfiles/assets

# stop and remove artifacts of the application
clean:
	# Stops containers and removes containers
	# (even for services not defined in the Compose file),
	# networks, volumes, and images created by up
	docker-compose down -v --remove-orphans

	# Delete the refs to remote branches from origin that no longer exist
	git remote prune origin

# remove staticfiles
cleandist:
	sudo rm -rf dist/*


# extended
.PHONY: help configure rmenvs rmdirs

# show this help
help:
	@awk '/^#/{c=substr($$0,3);next}c&&/^[[:alpha:]][[:alnum:]_-]+:/{print substr($$1,1,index($$1,":")),c}1{c=0}' $(MAKEFILE_LIST) | column -s: -t

# run a helper script to generate environment to run the application
configure:
	python3 configure.py

# remove environment files
rmenvs:
	rm -f .env
	rm -f app/.env
	rm -f mysql/.env

# remove directories
rmdirs:
	sudo rm -rf mysql/data
	sudo rm -rf app/content


# docker-compose
.PHONY: up down restart images images-pull

# start the application
up:
	docker-compose up

# stop and remove artifacts of the application
down:
	docker-compose down --remove-orphans

# restart the application
restart: down up

# create docker images
images:
	docker-compose build --force-rm

# create docker images with pull
images-pull:
	docker-compose pull
	docker-compose build --force-rm --pull


# development tools
.PHONY: lint format test bdd coverage

# open a bash CLI in the application container
bash:
	docker-compose run --rm app ash

# App
.PHONY: install-alpine install-htmx install-tailwind build-tailwind

install-alpine:
	mkdir -p app/alpine
	wget https://cdn.jsdelivr.net/npm/alpinejs@3.14.1/dist/cdn.min.js -O app/alpine/alpine.min.js

install-htmx:
	mkdir -p app/htmx
	wget https://unpkg.com/htmx.org@2.0.2/dist/htmx.min.js -O app/htmx/htmx.min.js
	docker-compose run --rm app bash -c "cd /app/tailwind; npm install tailwind-htmx"

install-tailwind:
	docker-compose run --rm app bash -c "cd /app/tailwind; npm install tailwindcss \
                                                            	       @tailwindcss/aspect-ratio \
                                                            	       @tailwindcss/forms \
                                                            	       @tailwindcss/line-clamp \
                                                            	       @tailwindcss/typography"

build-tailwind:
	docker-compose run --rm app bash -c "cd /app/tailwind; npx tailwindcss -i main.css -o src/tailwind.css"

new-theme:
	mkdir -p app/themes/$(THEME)
	cp -rv  app/themes/starter/assets app/themes/$(THEME)/
	cp -rv  app/themes/starter/members app/themes/$(THEME)/
	cp -rv  app/themes/starter/partials app/themes/$(THEME)/
	cp -rv  app/themes/starter/*.hbs app/themes/$(THEME)/
	cp -rv  app/themes/starter/*.json app/themes/$(THEME)/
	cp -rv  app/themes/starter/*.js app/themes/$(THEME)/
	cp -rv  app/themes/starter/.editorconfig app/themes/$(THEME)/
	cp -rv  app/themes/starter/.gitignore app/themes/$(THEME)/
	cp -rv  app/themes/starter/LICENSE app/themes/$(THEME)/
	cp -rv  app/themes/starter/yarn.lock app/themes/$(THEME)/
	echo "#$(THEME)" > app/themes/$(THEME)/README.md
	docker-compose run --rm app ash -c "cd /app/themes/$(THEME); npm install"

update-theme-tailwind: build-tailwind
	cp app/tailwind/src/tailwind.css app/themes/$(THEME)/assets/css/tailwind.css

build-theme: update-theme-tailwind
	docker-compose run --rm app ash -c "cd /app/themes/$(THEME); npm run zip"
	cp app/themes/$(THEME)/$(THEME)-theme.zip dist/

uninstall-theme:
	sudo rm -r app/themes/$(THEME)
