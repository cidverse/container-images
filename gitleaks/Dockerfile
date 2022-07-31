# platforms=linux/amd64,linux/arm64
# image=quay.io/cidverse/gitleaks

# build binary
#
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=zricethezav/gitleaks
ARG GITLEAKS_VERSION=8.9.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# linux/amd64
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then \
    file-download "/cache/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_x64.tar.gz" && \
    tar xzvf "/cache/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/gitleaks /usr/local/bin/gitleaks \
    ; fi

# linux/arm64
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then \
    file-download "/cache/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_arm64.tar.gz" && \
    tar xzvf "/cache/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/gitleaks /usr/local/bin/gitleaks \
    ; fi

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/gitleaks /usr/local/bin/gitleaks

USER 1001
CMD ["gitleaks"]
