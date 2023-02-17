# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/grype

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1760.1675784957 AS builder

# renovate: datasource=github-releases depName=anchore/grype
ARG GRYPE_VERSION=0.57.1
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# cidverse-download
RUN file-download "/cache/grype_${GRYPE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" && \
    file-download "/cache/grype_${GRYPE_VERSION}_${TARGETOS}_${TARGETARCH}.sha256sum" "https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_checksums.txt" && \
    tar xzvf "/cache/grype_${GRYPE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/grype /usr/local/bin/grype

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-13

COPY --from=builder /usr/local/bin/grype /usr/local/bin/grype

RUN mkdir -p /app/.cache/grype/db && \
    chgrp -R 0 /app/.cache/grype && \
    chmod -R g=u /app/.cache/grype

CMD ["grype"]
