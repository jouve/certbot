#!/bin/bash -x

sudo nerdctl run \
  --volume $PWD:/srv \
  --workdir /srv \
  $(sed -n -e '/FROM /{s/FROM //; p; q }' Dockerfile | head -n1) sh -x -c 'poetry lock'
