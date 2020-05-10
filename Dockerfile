FROM alpine:3.11.6

COPY Pipfile Pipfile.lock /

RUN set -e; \
    apk add --no-cache python3; \
    python3 -m venv /tmp/pipenv; \
    /tmp/pipenv/bin/pip install appdirs==1.4.3 certifi==2020.4.5.1 distlib==0.3.0 filelock==3.0.12 pipenv==2018.11.26 six==1.14.0 virtualenv==20.0.20 virtualenv-clone==0.5.4; \
    /tmp/pipenv/bin/pipenv lock -r > requirements.txt

FROM alpine:3.11.6

COPY --from=0 /requirements.txt /

RUN set -e; \
    apk add --no-cache libffi python3 \
                       gcc libffi-dev make musl-dev openssl-dev python3-dev; \
    pip3 install --no-cache-dir -r requirements.txt; \
    find -name __pycache__ | xargs rm -rf; \
    rm -rf /root/.cache; \
    apk del --no-cache gcc libffi-dev make musl-dev openssl-dev python3-dev

VOLUME /etc/letsencrypt
