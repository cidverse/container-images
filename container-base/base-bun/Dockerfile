# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-bun

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.3-1475 AS builder

# renovate: datasource=github-releases depName=oven-sh/bun
ARG BUN_VERSION=0.2.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# cidverse-download
RUN pkg-install-rootfs unzip && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=aarch64; fi && \
    file-download "/cache/bun-${BUN_VERSION}-${TARGETOS}-${TARGETARCH}.zip" "https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}/bun-${TARGETOS}-${TARGETARCH}.zip" && \
    unzip "/cache/bun-${BUN_VERSION}-${TARGETOS}-${TARGETARCH}.zip" -d /tmp && \
    mkdir -p /usr/lib/bun && \
    mv /tmp/bun-${TARGETOS}-${TARGETARCH}/bun /usr/local/bin/bun

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-13

COPY --from=builder /rootfs /
COPY --from=builder /usr/local/bin/bun /usr/local/bin/bun
