# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/grype

# build binary
# 
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=anchore/grype
ARG GRYPE_VERSION=0.43.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN cidverse-download "grype_${GRYPE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" \
&&  tar xzvf "/cache/grype_${GRYPE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ \
&&  mv /tmp/grype /usr/local/bin/grype

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/grype /usr/local/bin/grype

USER 1001
CMD ["grype"]
