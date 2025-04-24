# Ghost Blog Theme

A simple repository to create Ghost Themes with TailwindCSS, HTMx and AlpineJS 

## Requirements

My projects are designed to be executed in a Unix environment, and it can be executed with this small set of tools.

My current configuration is available below: 

- GNU Make 4.3 
- Python 3.12.3
- Docker CE 27.5.1
- Docker Compose plugin 2.32.4

## Install

```shell
make install
```

## Start

Run the development stack

```shell
make up
```

Set up Ghost instance -> http://127.0.0.1:2368/ghost/

Create a new theme

```shell
export THEME=example && make new-theme
```

Change `name` in  `app/themes/$THEME/package.json`

Build a distributed version of the theme for Ghost 

```shell
export THEME=example && make build-theme
```

If finished or deprecated, you can remove the theme with

```shell
export THEME=example && make remove-theme
```

http://127.0.0.1:2368/ghost/#/settings/design/change-theme


## Documentation

- https://hub.docker.com/_/ghost
- https://hub.docker.com/_/mysql
