# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/cosign

# compile the twitch cli binary
# 
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=1.10.0
ARG TARGETOS
ARG TARGETARCH

RUN file-download "/cache/cosign-${TARGETOS}-${TARGETARCH}" "https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-${TARGETOS}-${TARGETARCH}" &&\
    cp /cache/cosign-${TARGETOS}-${TARGETARCH} /usr/local/bin/cosign

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/cosign /usr/local/bin/cosign

USER 1001
CMD ["cosign"]
