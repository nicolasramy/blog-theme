FROM node:10-alpine

RUN npm install -g gscan
RUN npm install -g ghost-cli@latest

RUN mkdir /app

WORKDIR /app
VOLUME /app
ADD . /app

USER node

CMD ["ghost", "run"]
