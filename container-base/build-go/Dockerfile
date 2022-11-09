# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/build-go

# build
#
FROM quay.io/cidverse/base-ubi-build:9.0.0-1700 AS builder

# renovate: datasource=github-releases depName=golang/go
ARG GO_VERSION=1.19.3
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install gcc && \
    file-download "/cache/go-${GO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "https://go.dev/dl/go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz" && \
    tar -xf "/cache/go-${GO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp && \
    mkdir -p /usr/lib/go && \
    mv /tmp/go/* /usr/lib/go && \
    rm -rf /tmp/go

ENV PATH="${PATH}:/usr/lib/go/bin"
RUN go version
