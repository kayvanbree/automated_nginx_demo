FROM mhart/alpine-node:10

COPY package.json /usr/src/app/package.json
COPY package-lock.json /usr/src/app/package-lock.json
COPY src /usr/src/app/src/
COPY angular.json /usr/src/app
COPY tsconfig.json /usr/src/app

WORKDIR /usr/src/app
