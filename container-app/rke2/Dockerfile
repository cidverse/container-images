# platforms=linux/amd64,linux/s390x
# image=quay.io/cidverse/rke2

# build
#
FROM quay.io/cidverse/base-ubi-build:9.5-1734497536 AS builder

# renovate: datasource=github-releases depName=rancher/rke2
ARG RKE_VERSION=1.30.3+rke2r1
ARG RKE_REVISION=rke2r1
ARG TARGETOS
ARG TARGETARCH

RUN file-download /usr/local/bin/rke2 https://github.com/rancher/rke2/releases/download/v${RKE_VERSION}+${RKE_REVISION}/rke2.${TARGETOS}-${TARGETARCH} && \
    chmod +x /usr/local/bin/rke2

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.5-1734513256

COPY --from=builder /usr/local/bin/rke2 /usr/local/bin/rke2
RUN rke2 --version

CMD ["rke2"]
