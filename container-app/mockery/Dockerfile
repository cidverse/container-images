# platforms=linux/amd64
# image=quay.io/cidverse/mockery

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.2-750 AS builder

# renovate: datasource=github-releases depName=vektra/mockery
ARG MOCKERY_VERSION=2.35.4
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# cidverse-download
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x86_64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=arm64; fi && \
    file-download "/cache/mockery_${MOCKERY_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/vektra/mockery/releases/download/v${MOCKERY_VERSION}/mockery_${MOCKERY_VERSION}_Linux_${TARGETARCH}.tar.gz" && \
    tar -xzf "/cache/mockery_${MOCKERY_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp && \
    mv /tmp/mockery /usr/local/bin/mockery

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.2-13

COPY --from=builder /usr/local/bin/mockery /usr/local/bin/mockery
RUN mockery --version

CMD ["mockery"]
