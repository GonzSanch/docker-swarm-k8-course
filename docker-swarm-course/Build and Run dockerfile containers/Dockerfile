FROM node:6-alpine

RUN apk add --update tini

WORKDIR /usr/src/app

COPY package.json .

RUN npm i && npm cache clean --force

COPY . .

EXPOSE 3000

CMD ["/sbin/tini", "--", "node", "./bin/www"]