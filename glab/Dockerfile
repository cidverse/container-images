# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/glab

# build binary
# 
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=profclems/glab
ARG GLAB_VERSION=1.22.0
ARG TARGETOS
ARG TARGETARCH

RUN mkdir -p /tmp/download /tmp/glab \
&&  curl -L -o /tmp/download/glab-${GLAB_VERSION}.tar.gz https://github.com/profclems/glab/releases/download/v${GLAB_VERSION}/glab_${GLAB_VERSION}_Linux_x86_64.tar.gz \
&&  tar -xzf /tmp/download/glab-${GLAB_VERSION}.tar.gz -C /tmp/glab \
&&  cp /tmp/glab/bin/glab /usr/local/bin/glab

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/glab /usr/local/bin/glab

USER 1001
CMD ["glab"]
