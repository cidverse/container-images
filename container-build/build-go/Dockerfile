# platforms=linux/amd64
# image=quay.io/cidverse/build-go

# build
#
FROM quay.io/cidverse/base-ubi-build:9.5-1734497536 AS builder

# renovate: datasource=github-tags depName=golang/go
ARG GO_VERSION=1.23.4
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN file-download "/cache/go-${GO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "https://go.dev/dl/go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz" && \
    tar -xf "/cache/go-${GO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp && \
    mkdir -p /usr/lib/go && \
    mv /tmp/go/* /usr/lib/go && \
    rm -rf /tmp/go && \
    mkdir -p /go /go/pkg/mod && \
    chmod -R 775 /go && \
    chgrp -R 0 /go && \
    chmod -R g=u /go

ENV GOROOT=/usr/lib/go
ENV GOPATH=/go
ENV PATH="${PATH}:/usr/lib/go/bin"
RUN go version
