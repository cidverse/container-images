# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/rke

# build
#
FROM quay.io/cidverse/base-ubi-build:latest AS builder

# renovate: datasource=github-releases depName=rancher/rke
ARG RKE_VERSION=1.3.13
ARG TARGETOS
ARG TARGETARCH

RUN file-download /usr/local/bin/rke https://github.com/rancher/rke/releases/download/v${RKE_VERSION}/rke_${TARGETOS}-${TARGETARCH}

# runtime image
#
FROM quay.io/cidverse/base-ubi:latest

COPY --from=builder /usr/local/bin/rke /usr/local/bin/rke

USER 1001
CMD ["rke"]
