# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/rekor

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.5-1734497536 AS builder

# renovate: datasource=github-releases depName=sigstore/rekor
ARG REKOR_VERSION=1.3.10
ARG TARGETOS
ARG TARGETARCH

RUN file-download "/cache/rekor-cli-${TARGETOS}-${TARGETARCH}" "https://github.com/sigstore/rekor/releases/download/v${REKOR_VERSION}/rekor-cli-${TARGETOS}-${TARGETARCH}" && \
    cp "/cache/rekor-cli-${TARGETOS}-${TARGETARCH}" /usr/local/bin/rekor && \
    chmod +x /usr/local/bin/rekor

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.5-1734513256

COPY --from=builder /usr/local/bin/rekor /usr/local/bin/rekor
RUN rekor version

CMD ["rekor"]
