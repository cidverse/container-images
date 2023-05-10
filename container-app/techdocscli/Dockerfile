# platforms=linux/amd64,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/techdocscli

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.2-484 AS builder

# renovate: datasource=pypi depName=mkdocs-techdocs-core
ARG MKDOCS_TECHDOCS_CORE=1.2.0

RUN pkg-install python3-pip && \
    pkg-install-rootfs python3 && \
    pip3 install --upgrade pip && \
    pip3 install --root="/rootfs" --no-warn-script-location mkdocs-techdocs-core==${MKDOCS_TECHDOCS_CORE}

# runtime image
#
FROM quay.io/cidverse/base-node:20.1.0
COPY --from=builder /rootfs /

# renovate: datasource=npm depName=@techdocs/cli
ARG TECHDOCS_VERSION=1.4.1

USER root
RUN npm install -g --omit=dev @techdocs/cli@${TECHDOCS_VERSION}

RUN techdocs-cli --version
CMD ["techdocs-cli"]
