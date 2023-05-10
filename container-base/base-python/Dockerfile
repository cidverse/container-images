# platforms=linux/amd64
# image=quay.io/cidverse/base-python

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.2-484 AS builder

## renovate: datasource=github-releases depName=python/cpython
ARG PYTHON_VERSION=3.9.14
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs python3

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.2-5

COPY --from=builder /rootfs /
RUN python3 --version

CMD ["python3"]
