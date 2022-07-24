# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/rke

# compile the twitch cli binary
# 
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=rancher/rke
ARG RKE_VERSION=1.3.12
ARG TARGETOS
ARG TARGETARCH

RUN curl -L --output /usr/local/bin/rke https://github.com/rancher/rke/releases/download/v${RKE_VERSION}/rke_${TARGETOS}-${TARGETARCH}

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/rke /usr/local/bin/rke

USER 1001
CMD ["rke"]
