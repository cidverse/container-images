# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/build-python

# build
#
FROM quay.io/cidverse/base-ubi-build:9.4-1227.1726694542 AS builder

# renovate: datasource=github-releases depName=python/cpython
ARG PYTHON_VERSION=3.12.3
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install python3.12 python3.12-pip && \
    ln -s /usr/bin/python3.12 /usr/bin/python3 && \
    ln -s /usr/bin/pip3.12 /usr/bin/pip3 && \
    python3 -m pip install pipx

RUN python3 --version && \
    pip3 --version && \
    pipx --version
