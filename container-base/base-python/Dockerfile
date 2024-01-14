# platforms=linux/amd64
# image=quay.io/cidverse/base-python

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.3-1361.1699548032 AS builder

## renovate: datasource=github-releases depName=python/cpython
ARG PYTHON_VERSION=3.11.2
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs python3.11

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-9

COPY --from=builder /rootfs /
RUN ln -s /usr/bin/python3.11 /usr/bin/python3
RUN python3 --version

CMD ["python3"]
