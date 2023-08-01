# platforms=linux/amd64
# image=quay.io/cidverse/oras

# build
#
FROM quay.io/cidverse/base-ubi-build:9.2-691 AS builder

# renovate: datasource=github-releases depName=oras-project/oras
ARG ORAS_VERSION=1.0.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN file-download "/cache/oras-${ORAS_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" && \
    tar xzvf "/cache/oras-${ORAS_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/oras /usr/local/bin/oras

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.2-13

COPY --from=builder /usr/local/bin/oras /usr/local/bin/oras
ENV ORAS_CACHE=/app/cache/oras

CMD ["oras"]
