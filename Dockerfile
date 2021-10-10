FROM jouve/poetry:1.1.10-alpine3.14.2

COPY pyproject.toml poetry.lock /srv/

WORKDIR /srv

RUN poetry export --without-hashes > /requirements.txt

FROM alpine:3.14.2

COPY --from=0 /requirements.txt /usr/share/certbot/requirements.txt

RUN set -e; \
    apk add --no-cache --virtual .build-deps \
        gcc \
        libffi-dev \
        make \
        musl-dev \
        python3-dev \
    ; \
    python3 -m venv /usr/share/certbot; \
    /usr/share/certbot/bin/pip install pip==21.2.4 wheel==0.37.0; \
    /usr/share/certbot/bin/pip install -r /usr/share/certbot/requirements.txt; \
    apk add --no-cache --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/share/certbot \
        | tr ',' '\n' \
        | sed 's/^/so:/' \
        | sort -u \
        | grep -v libgcc_s \
    ); \
    apk del --no-cache .build-deps; \
    rm -rf /root/.cache /root/.cargo

RUN ln -s /usr/share/certbot/bin/certbot /usr/bin
VOLUME /etc/letsencrypt
ENTRYPOINT ["certbot"]
