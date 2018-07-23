FROM node:10-alpine

RUN mkdir /app
WORKDIR /app

VOLUME /app

ADD . /app
