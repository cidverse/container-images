# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/cosign

# compile the twitch cli binary
# 
FROM quay.io/cidverse/common-minimal:latest

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=1.10.0
ARG TARGETOS
ARG TARGETARCH

RUN curl -L --output /usr/local/bin/cosign https://github.com/sigstore/cosign/releases/download/v{$COSIGN_VERSION}/cosign-${TARGETOS}-${TARGETARCH}

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=0 /usr/local/bin/cosign /usr/local/bin/cosign

USER 1001
CMD ["cosign"]
