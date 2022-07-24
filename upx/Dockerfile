# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64
# image=quay.io/cidverse/upx

# compile the twitch cli binary
# 
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=upx/upx
ARG UPX_VERSION=3.96
ARG TARGETOS
ARG TARGETARCH

RUN curl -L -o /tmp/upx-${UPX_VERSION}.tar.gz https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${TARGETARCH}_${TARGETOS}.tar.xz \
&&  tar -xf /tmp/upx-${UPX_VERSION}.tar.gz -C /tmp \
&&  cp /tmp/upx-${UPX_VERSION}-${TARGETARCH}_${TARGETOS}/upx /usr/local/bin/upx

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/upx /usr/local/bin/upx

USER 1001
CMD ["upx"]
