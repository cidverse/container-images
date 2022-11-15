# platforms=linux/amd64,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/techdocscli

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1656 AS builder

# renovate: datasource=pypi depName=mkdocs-techdocs-core
ARG MKDOCS_TECHDOCS_CORE=1.1.7

RUN pkg-install python3-pip && \
    pkg-install-rootfs python3 && \
    pip3 install --upgrade pip && \
    pip3 install --root="/rootfs" --no-warn-script-location mkdocs-techdocs-core==${MKDOCS_TECHDOCS_CORE}

# runtime image
#
FROM quay.io/cidverse/base-node:19.0.1
COPY --from=builder /rootfs /

# renovate: datasource=npm depName=@techdocs/cli
ARG TECHDOCS_VERSION=1.2.3

USER root
RUN npm install -g --omit=dev @techdocs/cli@${TECHDOCS_VERSION}

USER 1001
RUN techdocs-cli --version
CMD ["techdocs-cli"]
