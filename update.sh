#!/bin/bash -x

if ! test -w /var/run/docker.sock; then
  SUDO=sudo
else
  SUDO=
fi
$SUDO docker run -it -v $PWD:/srv -w /srv $(head -n1 Dockerfile | sed -n -e 's/FROM //p') sh -c "
set -e
apk add --no-cache gcc libffi-dev make musl-dev openssl-dev python3-dev
pip3 install --upgrade pip
pip install pipenv
pip freeze
pipenv lock
"
