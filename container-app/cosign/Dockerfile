# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/cosign

# build image
# 
FROM quay.io/cidverse/base-ubi-build:9.2-717 AS builder

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=2.1.1
ARG TARGETOS
ARG TARGETARCH

RUN file-download "/cache/cosign-${COSIGN_VERSION}-${TARGETOS}-${TARGETARCH}" "https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-${TARGETOS}-${TARGETARCH}" && \
    cp /cache/cosign-${COSIGN_VERSION}-${TARGETOS}-${TARGETARCH} /usr/local/bin/cosign && \
    chmod +x /usr/local/bin/cosign

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.2-13

COPY --from=builder /usr/local/bin/cosign /usr/local/bin/cosign
RUN cosign version

CMD ["cosign"]
