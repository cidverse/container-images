# platforms=linux/amd64,linux/arm64
# image=quay.io/cidverse/glab

# build binary
#
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=profclems/glab
ARG GLAB_VERSION=1.22.0
ARG TARGETOS
ARG TARGETARCH

# linux/amd64
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then \
    file-download "/cache/glab-${GLAB_VERSION}_x86_64.tar.gz" https://github.com/profclems/glab/releases/download/v${GLAB_VERSION}/glab_${GLAB_VERSION}_Linux_x86_64.tar.gz && \
    tar -xzf "/cache/glab-${GLAB_VERSION}_x86_64.tar.gz" -C /tmp && \
    cp /tmp/bin/glab /usr/local/bin/glab \
    ; fi

# linux/arm64
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then \
    file-download "/cache/glab-${GLAB_VERSION}_arm64.tar.gz" https://github.com/profclems/glab/releases/download/v${GLAB_VERSION}/glab_${GLAB_VERSION}_Linux_arm64.tar.gz && \
    tar -xzf "/cache/glab-${GLAB_VERSION}_arm64.tar.gz" -C /tmp && \
    cp /tmp/bin/glab /usr/local/bin/glab \
    ; fi

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/glab /usr/local/bin/glab

USER 1001
CMD ["glab"]
