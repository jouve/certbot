FROM jouve/poetry:1.1.14-alpine3.16.0

COPY pyproject.toml poetry.lock /srv/

WORKDIR /srv

RUN poetry export --without-hashes > /requirements.txt

FROM alpine:3.16.0

COPY --from=0 /requirements.txt /usr/share/certbot/requirements.txt

RUN set -e; \
    apk add --no-cache --virtual .build-deps \
        build-base \
        libffi-dev \
        python3-dev \
    ; \
    python3 -m venv /usr/share/certbot; \
    /usr/share/certbot/bin/pip install --no-cache-dir pip==22.1.2 setuptools==63.1.0 wheel==0.37.1; \
    /usr/share/certbot/bin/pip install --no-cache-dir --requirement /usr/share/certbot/requirements.txt; \
    apk add --no-cache --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/share/certbot \
        | tr ',' '\n' \
        | sed 's/^/so:/' \
        | sort -u \
        | grep -v libgcc_s \
    ); \
    apk del --no-cache .build-deps; \
    rm /tmp/*

RUN ln -s /usr/share/certbot/bin/certbot /usr/bin
VOLUME /etc/letsencrypt
ENTRYPOINT ["certbot"]
