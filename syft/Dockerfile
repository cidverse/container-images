# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/syft

# build binary
# 
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=anchore/syft
ARG SYFT_VERSION=0.52.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# cidverse-download "syft_${SYFT_VERSION}_${TARGETOS}_${TARGETARCH}.sha256sum" "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_checksums.txt"
RUN cidverse-download "syft_${SYFT_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" \
&&  tar xzvf "/cache/syft_${SYFT_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ \
&&  mv /tmp/syft /usr/local/bin/syft

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/syft /usr/local/bin/syft
COPY --from=builder /etc/pki/ca-trust /etc/pki/ca-trust

USER 1001
CMD ["syft"]
