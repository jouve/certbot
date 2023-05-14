#!/bin/bash

docker () { sudo nerdctl "$@"; }
docker run -v $PWD/letsencrypt:/etc/letsencrypt jouve/certbot certonly "$@"
