# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/gitleaks

# build binary
# 
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=zricethezav/gitleaks
ARG GITLEAKS_VERSION=8.9.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN cidverse-download "gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_x64.tar.gz" \
&&  tar xzvf "/cache/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ \
&&  mv /tmp/gitleaks /usr/local/bin/gitleaks

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/gitleaks /usr/local/bin/gitleaks

USER 1001
CMD ["gitleaks"]
