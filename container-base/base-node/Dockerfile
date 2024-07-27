# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/base-node

# build
#
FROM quay.io/cidverse/base-ubi-build:9.4-1134 AS builder

# renovate: datasource=github-releases depName=nodejs/node
ARG NODE_VERSION=22.5.1
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
FROM quay.io/cidverse/base-ubi:9.4-13

COPY --from=builder /rootfs /
COPY --from=builder /usr/lib/node /usr/lib/node
ENV NODE_HOME="/usr/lib/node"
ENV NODE_ENV="production"
ENV NODE_EXTRA_CA_CERTS="/etc/pki/tls/certs/ca-bundle.crt"
ENV PATH="${PATH}:/usr/lib/node/bin"
RUN npm install -g npm

RUN node --version && \
    npm --version
CMD ["node"]
