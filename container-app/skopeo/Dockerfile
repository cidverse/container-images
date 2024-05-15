# platforms=linux/amd64
# image=quay.io/cidverse/skopeo

# build
#
FROM quay.io/cidverse/build-go:1.22.2 AS builder

# renovate: datasource=github-releases depName=containers/skopeo
ARG SKOPEO_VERSION=1.15.1
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install gpgme-devel libassuan-devel device-mapper-devel && \
    pkg-install-rootfs containers-common gpgme device-mapper && \
    mkdir -p /go/src/github.com/containers && \
    git clone --depth 1 --branch v${SKOPEO_VERSION} https://github.com/containers/skopeo.git /go/src/github.com/containers/skopeo && \
    cd /go/src/github.com/containers/skopeo && \
    env GOPATH=/go DISABLE_DOCS=1 make -C /go/src/github.com/containers/skopeo clean bin/skopeo && \
    cp /go/src/github.com/containers/skopeo/bin/skopeo /usr/local/bin/skopeo

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-6

COPY --from=builder /rootfs /
COPY --from=builder /usr/local/bin/skopeo /usr/local/bin/skopeo

RUN skopeo --version
CMD ["skopeo"]
