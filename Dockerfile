# This file describes how to build hipache into a runnable linux container with all dependencies installed
# To build:
# 1) Install docker (http://docker.io)
# 2) Clone hipache repo if you haven't already: git clone https://github.com/hickey/hipache-router.git
# 3) Build: cd hipache-router && docker build .
# 4) Run:
# docker run -d <imageid>
# redis-cli
#
# VERSION		0.2
# DOCKER-VERSION	0.8.0

FROM ubuntu:12.04

RUN  echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN  apt-get -y update
RUN  apt-get -y install wget git redis-server supervisor
RUN  wget -O - http://nodejs.org/dist/v0.10.25/node-v0.10.25-linux-x64.tar.gz | tar -C /usr/local/ --strip-components=1 -zxv
RUN  npm install -g http://github.com/hickey/hipache-router.git

RUN  mkdir -p /var/log/supervisor
ADD  ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD  ./config/config_dev.json /usr/local/lib/node_modules/hipache/config/config_dev.json
ADD  ./config/config_test.json /usr/local/lib/node_modules/hipache/config/config_test.json
ADD  ./config/config.json /usr/local/lib/node_modules/hipache/config/config.json

EXPOSE  80
EXPOSE  2112
EXPOSE  6379

CMD  ["supervisord", "-n"]
