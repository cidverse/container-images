# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/rke

# build
#
FROM quay.io/cidverse/base-ubi-build:9.4-1134 AS builder

# renovate: datasource=github-releases depName=rancher/rke
ARG RKE_VERSION=1.6.0
ARG TARGETOS
ARG TARGETARCH

RUN file-download /usr/local/bin/rke https://github.com/rancher/rke/releases/download/v${RKE_VERSION}/rke_${TARGETOS}-${TARGETARCH} && \
    chmod +x /usr/local/bin/rke

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-9

COPY --from=builder /usr/local/bin/rke /usr/local/bin/rke
RUN rke --version

CMD ["rke"]
