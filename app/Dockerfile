FROM ghost:5-alpine

LABEL mantainer="Nicolas Ramy <nicolas.ramy@darkelda.com>"

RUN npm install -g gscan \
                   ghost-cli@latest

RUN mkdir /app
COPY . /app

VOLUME ["/app"]

