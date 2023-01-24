# platforms=linux/amd64,linux/arm64/v8,linux/ppc64le
# image=quay.io/cidverse/upx

# compile the twitch cli binary
# 
FROM quay.io/cidverse/base-ubi-build:9.1.0-1760 AS builder

# renovate: datasource=github-releases depName=upx/upx
ARG UPX_VERSION=4.0.1
ARG TARGETOS
ARG TARGETARCH

RUN if [ "$TARGETOS/$TARGETARCH" == "linux/ppc64le" ]; then export TARGETARCH=powerpc64le; fi && \
    curl -L -o /tmp/upx-${UPX_VERSION}.tar.gz https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${TARGETARCH}_${TARGETOS}.tar.xz && \
    tar -xf /tmp/upx-${UPX_VERSION}.tar.gz -C /tmp && \
    cp /tmp/upx-${UPX_VERSION}-${TARGETARCH}_${TARGETOS}/upx /usr/local/bin/upx

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-13

COPY --from=builder /usr/local/bin/upx /usr/local/bin/upx

CMD ["upx"]
