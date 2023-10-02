#!/bin/bash

kubectl --namespace haproxy-controller delete secret kubernetes-ingress-default-cert
kubectl --namespace haproxy-controller create secret tls kubernetes-ingress-default-cert --cert letsencrypt/live/*/fullchain.pem --key letsencrypt/live/*/privkey.pem
