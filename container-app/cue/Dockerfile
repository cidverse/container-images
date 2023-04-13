# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/cue

# build binary
# 
FROM quay.io/cidverse/base-ubi-build:9.1.0-1829 AS builder

# renovate: datasource=github-releases depName=cue-lang/cue
ARG CUE_VERSION=0.5.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN file-download /cache/cue_v${CUE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz https://github.com/cue-lang/cue/releases/download/v${CUE_VERSION}/cue_v${CUE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz && \
    tar -xzf /cache/cue_v${CUE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz -C /tmp && \
    cp /tmp/cue /usr/local/bin/cue && \
    rm -rf /tmp/*

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-15

COPY --from=builder /usr/local/bin/cue /usr/local/bin/cue

CMD ["cue"]
