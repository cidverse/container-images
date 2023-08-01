# platforms=linux/amd64
# image=quay.io/cidverse/mkdocs

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.2-691 AS builder

# renovate: datasource=pypi depName=mkdocs
ARG MKDOCS_VERSION=1.5.1

# renovate: datasource=pypi depName=mkdocs-material
ARG MKDOCS_MATERIAL=9.1.21

RUN pkg-install python3-pip ca-certificates && \
    pkg-install-rootfs python3 && \
    pip3 install --upgrade pip && \
    pip3 install --root="/rootfs" --no-warn-script-location mkdocs==${MKDOCS_VERSION} && \
    pip3 install --root="/rootfs" --no-warn-script-location mkdocs-material==${MKDOCS_MATERIAL}

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.2-13
COPY --from=builder /rootfs /
RUN mkdocs --version

CMD ["mkdocs"]
