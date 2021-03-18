#!/bin/bash

kubectl --namespace haproxy-ingress create secret tls tls-secret --cert letsencrypt/live/*/fullchain.pem --key letsencrypt/live/*/privkey.pem
