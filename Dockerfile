FROM alpine:3.12.1

COPY poetry.txt /

RUN set -e; \
    apk add --no-cache gcc libffi-dev musl-dev openssl-dev python3-dev; \
    python3 -m venv /usr/share/poetry; \
    /usr/share/poetry/bin/pip install -c /poetry.txt pip; \
    /usr/share/poetry/bin/pip install -c /poetry.txt wheel; \
    /usr/share/poetry/bin/pip install -c /poetry.txt poetry

COPY pyproject.toml poetry.lock /srv/

WORKDIR /srv

RUN /usr/share/poetry/bin/poetry export > /requirements.txt

FROM alpine:3.12.1

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
