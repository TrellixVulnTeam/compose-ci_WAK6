FROM alpine:edge

COPY repositories /etc/apk/repositories

RUN apk add --no-cache \
    docker \
    python3 \
    curl \
    unzip \
    aha@testing \
    bash \
    && pip3 install docker-compose awscli \
    && rm -rf \
        /tmp/* \
        /root/.cache \
        /var/cache/apk \
        $(find / -regex '.*\.py[co]')

EXPOSE 80

ENV DOCKER_HOST=unix:///var/run/docker.sock
ENV BUILD_IMAGE=docteurklein/compose-ci
ENV BUILD_CMD=/ci/bash/ci.sh
ENV GARBAGE_COLLECT=1
ENV HOOK='/ci/hook "docker-compose run --rm tests"'

WORKDIR /ci

CMD ["python3", "/ci/python/httpd.py"]

COPY . /ci
