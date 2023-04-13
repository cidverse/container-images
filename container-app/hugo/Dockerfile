# platforms=linux/amd64
# image=quay.io/cidverse/hugo

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1829 AS builder

# renovate: datasource=github-releases depName=gohugoio/hugo
ARG HUGO_VERSION=0.111.3
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# cidverse-download
RUN pkg-install-rootfs libstdc++ && \
    file-download "/cache/hugo_${HUGO_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    tar xzvf "/cache/hugo_${HUGO_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/hugo /usr/local/bin/hugo

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-17

COPY --from=builder /rootfs /
COPY --from=builder /usr/local/bin/hugo /usr/local/bin/hugo
RUN hugo version

CMD ["hugo"]
