# platforms=linux/amd64,linux/arm64/v8,linux/ppc64le
# image=quay.io/cidverse/syft

# build binary
# 
FROM quay.io/cidverse/base-ubi-build:9.4-949.1716471857 AS builder

# renovate: datasource=github-releases depName=anchore/syft
ARG SYFT_VERSION=1.6.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# cidverse-download 
RUN file-download "/cache/syft_${SYFT_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" && \
    file-download "/cache/syft_${SYFT_VERSION}_${TARGETOS}_${TARGETARCH}.sha256sum" "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_checksums.txt" && \
    tar xzvf "/cache/syft_${SYFT_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/syft /usr/local/bin/syft

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-9

COPY --from=builder /usr/local/bin/syft /usr/local/bin/syft

CMD ["syft"]
