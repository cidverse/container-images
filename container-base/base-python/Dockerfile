# platforms=linux/amd64
# image=quay.io/cidverse/base-python

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.5-1733767867 AS builder

# renovate: datasource=github-releases depName=python/cpython
ARG PYTHON_VERSION=3.12.3
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs python3.12

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.5-1734513256

COPY --from=builder /rootfs /
RUN ln -s /usr/bin/python3.12 /usr/bin/python3
RUN python3 --version

CMD ["python3"]
