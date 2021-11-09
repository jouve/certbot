#!/bin/bash

kubectl --namespace ingress-controller create secret tls default-ssl-certificate --cert letsencrypt/live/*/fullchain.pem --key letsencrypt/live/*/privkey.pem
