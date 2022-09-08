# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-node

# build
#
FROM quay.io/cidverse/base-ubi-build:latest AS builder

# renovate: datasource=github-releases depName=nodejs/node
ARG NODE_VERSION=18.9.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=arm64; fi && \
    file-download "/cache/node-${NODE_VERSION}-${TARGETOS}-${TARGETARCH}.tar.xz" "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${TARGETOS}-${TARGETARCH}.tar.xz" && \
    tar -xf "/cache/node-${NODE_VERSION}-${TARGETOS}-${TARGETARCH}.tar.xz" -C /tmp && \
    mkdir -p /usr/lib/node && \
    mv /tmp/node-v${NODE_VERSION}-${TARGETOS}-${TARGETARCH}/* /usr/lib/node && \
    pkg-install-rootfs libstdc++

# runtime image
#
FROM quay.io/cidverse/base-ubi:latest

COPY --from=builder /rootfs /
COPY --from=builder /usr/lib/node /usr/lib/node
ENV NODE_HOME=/usr/lib/node
ENV PATH="${PATH}:/usr/lib/node/bin"
RUN node --version && \
    npm install -g npm

USER 1001
CMD ["node"]
