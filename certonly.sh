#!/bin/bash

docker run -v $PWD/letsencrypt:/etc/letsencrypt jouve/certbot certonly "$@"
