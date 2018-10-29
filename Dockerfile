FROM alpine:latest

# Adds testing package to repositories
# Install needed packages. Notes:
#   * build-base: used so we include the basic development packages (gcc)
#   * python-dev: are used for gevent e.g.
#   * bash: so we can access /bin/bash

ENV http_proxy http://192.168.116.131:1337
ENV https_proxy http://192.168.116.131:1337
ENV HTTP_PROXY http://192.168.116.131:1337
ENV HTTPS_PROXY http://192.168.116.131:1337

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --update \
              musl \
              build-base \
              bash \
              git \
              python \
              python-dev \
              py-pip \
  && pip install --upgrade pip \
  && rm /var/cache/apk/*

# make some useful symlinks that are expected to exist
RUN cd /usr/bin \
  && ln -sf easy_install-2.7 easy_install \
  && ln -sf python2.7 python \
  && ln -sf python2.7-config python-config \
  && ln -sf pip2.7 pip

RUN pip install prometheus-client==0.0.14

EXPOSE 9184
COPY nexus_exporter.py /nexus_exporter.py

ENV http_proxy ""
ENV https_proxy ""
ENV HTTP_PROXY ""
ENV HTTPS_PROXY ""

ENTRYPOINT ["/nexus_exporter.py"]
