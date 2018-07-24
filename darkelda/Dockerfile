FROM node:10-alpine

RUN npm install -g grunt-cli

RUN mkdir /app
WORKDIR /app

VOLUME /app
ADD . /app

CMD ["sh"]
