FROM node:18.8.0-alpine

MAINTAINER jmonlong@ucsc.edu

## install http-server
RUN npm install --global http-server

## clone igv-webapp
WORKDIR /igv

RUN apk add --no-cache git && \
    git clone https://github.com/igvteam/igv-webapp.git webapp

## use my fork of igv.js and change default genome version
RUN sed -e 's/github:igvteam\/igv.js/github:jmonlong\/igv.js/' -i /igv/webapp/package.json && \
    sed -i -e 's/hg19/hg38/' /igv/webapp/igvwebConfig.js

## build it
WORKDIR /igv/webapp

RUN npm install && \
    npm run build
