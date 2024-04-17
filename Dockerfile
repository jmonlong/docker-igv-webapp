FROM ubuntu:22.04

MAINTAINER jmonlong@ucsc.edu

RUN apt-get update && apt-get install -y \
    npm \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

## install http-server
RUN npm install --global http-server

## update to latest stabl nodejs
RUN npm cache clean -f && \
    npm install -g n && \
    n stable

## clone igv-webapp
WORKDIR /igv

RUN git clone https://github.com/igvteam/igv-webapp.git webapp

## use my fork of igv.js
RUN sed -e 's/github:igvteam\/igv.js/github:jmonlong\/igv.js/' -i /igv/webapp/package.json

## build it
WORKDIR /igv/webapp

RUN npm install && \
    npm run build

## change default genome
RUN sed -i -e 's/hg19/hg38/' /igv/webapp/igvwebConfig.js

WORKDIR /igv/webapp
