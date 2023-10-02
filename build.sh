#!/bin/bash -x

docker build -t jouve/certbot:$(poetry export --without-hashes | sed -n -e 's/certbot==\([^ ;]\+\).*/\1/p')-alpine$(sed -n -e 's/FROM alpine://p' Dockerfile) .
