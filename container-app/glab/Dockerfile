# platforms=linux/amd64
# image=quay.io/cidverse/glab

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1760 AS builder

# renovate: datasource=gitlab-releases depName=profclems/glab
ARG GLAB_VERSION=1.25.0
ARG TARGETOS
ARG TARGETARCH

RUN pkg-install-rootfs git && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x86_64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=arm64; fi && \
    file-download "/cache/glab-${GLAB_VERSION}_${TARGETARCH}.tar.gz" https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_Linux_${TARGETARCH}.tar.gz && \
    tar -xzf "/cache/glab-${GLAB_VERSION}_${TARGETARCH}.tar.gz" -C /tmp && \
    cp /tmp/bin/glab /usr/local/bin/glab

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-13

COPY --from=builder /rootfs /
COPY --from=builder /usr/local/bin/glab /usr/local/bin/glab

RUN git --version && \
    glab --version

CMD ["glab"]
