# platforms=linux/amd64
# image=quay.io/cidverse/mkdocs

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.2-484 AS builder

# renovate: datasource=pypi depName=mkdocs
ARG MKDOCS_VERSION=1.4.3

# renovate: datasource=pypi depName=mkdocs-material
ARG MKDOCS_MATERIAL=9.1.10

RUN pkg-install python3-pip ca-certificates && \
    pkg-install-rootfs python3 && \
    pip3 install --upgrade pip && \
    pip3 install --root="/rootfs" --no-warn-script-location mkdocs==${MKDOCS_VERSION} && \
    pip3 install --root="/rootfs" --no-warn-script-location mkdocs-material==${MKDOCS_MATERIAL}

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-17
COPY --from=builder /rootfs /
RUN mkdocs --version

CMD ["mkdocs"]
