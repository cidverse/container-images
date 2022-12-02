# platforms=linux/amd64,linux/arm64
# image=quay.io/cidverse/gitleaks

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1656.1669627757 AS builder

# renovate: datasource=github-releases depName=zricethezav/gitleaks
ARG GITLEAKS_VERSION=8.15.2
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs git && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=arm64; fi && \
    file-download "/cache/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" && \
    tar xzvf "/cache/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/gitleaks /usr/local/bin/gitleaks

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-6

COPY --from=builder /rootfs /
COPY --from=builder /usr/local/bin/gitleaks /usr/local/bin/gitleaks

USER 1001
CMD ["gitleaks"]
