# platforms=linux/amd64
# image=quay.io/cidverse/gosec

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.4-1227.1725849298 AS builder

# renovate: datasource=github-releases depName=securego/gosec
ARG GOSEC_VERSION=2.21.4
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN file-download "/cache/gosec-${GOSEC_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "https://github.com/securego/gosec/releases/download/v${GOSEC_VERSION}/gosec_${GOSEC_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" && \
    tar xzvf "/cache/gosec-${GOSEC_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/gosec /usr/local/bin/gosec && \
    chmod +x /usr/local/bin/gosec

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-15

COPY --from=builder /usr/local/bin/gosec /usr/local/bin/gosec
RUN gosec -version

CMD ["gosec"]
