# platforms=linux/amd64,linux/arm64
# image=quay.io/cidverse/glab

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1656.1669627757 AS builder

# renovate: datasource=github-releases depName=profclems/glab
ARG GLAB_VERSION=1.22.0
ARG TARGETOS
ARG TARGETARCH

RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x86_64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=arm64; fi && \
    file-download "/cache/glab-${GLAB_VERSION}_${TARGETARCH}.tar.gz" https://github.com/profclems/glab/releases/download/v${GLAB_VERSION}/glab_${GLAB_VERSION}_Linux_${TARGETARCH}.tar.gz && \
    tar -xzf "/cache/glab-${GLAB_VERSION}_${TARGETARCH}.tar.gz" -C /tmp && \
    cp /tmp/bin/glab /usr/local/bin/glab

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-6

COPY --from=builder /usr/local/bin/glab /usr/local/bin/glab

CMD ["glab"]
