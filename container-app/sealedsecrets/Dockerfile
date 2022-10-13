# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/sealedsecrets

# build
#
FROM quay.io/cidverse/base-ubi-build:latest AS builder

# renovate: datasource=github-releases depName=bitnami-labs/sealed-secrets
ARG SEALEDSECRET_VERSION=0.19.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN file-download "/cache/kubeseal-${SEALEDSECRET_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${SEALEDSECRET_VERSION}/kubeseal-${SEALEDSECRET_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" && \
    tar xzvf "/cache/kubeseal-${SEALEDSECRET_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/kubeseal /usr/local/bin/kubeseal

# runtime image
#
FROM quay.io/cidverse/base-ubi:latest

COPY --from=builder /usr/local/bin/kubeseal /usr/local/bin/kubeseal

USER 1001
CMD ["kubeseal"]
