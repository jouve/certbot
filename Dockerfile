FROM alpine:3.12.0

COPY pipenv.txt /

RUN set -e; \
    apk add --no-cache python3; \
    python3 -m venv /tmp/pipenv; \
    /tmp/pipenv/bin/pip install -r /pipenv.txt

COPY Pipfile Pipfile.lock /srv/

WORKDIR /srv

RUN /tmp/pipenv/bin/pipenv lock -r > /requirements.txt

FROM alpine:3.12.0

COPY --from=0 /requirements.txt /usr/share/certbot/requirements.txt

RUN set -e; \
    apk add --no-cache libffi python3 \
                       gcc libffi-dev make musl-dev openssl-dev python3-dev; \
    python3 -m venv /usr/share/certbot; \
    /usr/share/certbot/bin/pip install --no-cache-dir -r /usr/share/certbot/requirements.txt; \
    find -name __pycache__ | xargs rm -rf; \
    rm -rf /root/.cache; \
    apk del --no-cache gcc libffi-dev make musl-dev openssl-dev python3-dev

RUN ln -s /usr/share/certbot/bin/certbot /usr/bin
VOLUME /etc/letsencrypt
ENTRYPOINT ["certbot"]
