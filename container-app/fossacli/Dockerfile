# platforms=linux/amd64
# image=quay.io/cidverse/fossacli

# build
#
FROM quay.io/cidverse/base-ubi-build:9.3-1552 AS builder

# renovate: datasource=github-releases depName=fossas/fossa-cli
ARG FOSSACLI_VERSION=3.9.10
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN file-download "/cache/fossa_${FOSSACLI_VERSION}_${TARGETOS}_${TARGETARCH}.zip" "https://github.com/fossas/fossa-cli/releases/download/v${FOSSACLI_VERSION}/fossa_${FOSSACLI_VERSION}_${TARGETOS}_${TARGETARCH}.zip" && \
    unzip "/cache/fossa_${FOSSACLI_VERSION}_${TARGETOS}_${TARGETARCH}.zip" -d /tmp && \
    cp /tmp/fossa /usr/local/bin/fossa

# runtime image
#
FROM quay.io/cidverse/base-coretto-11:11.0.22.7.1

COPY --from=builder /usr/local/bin /usr/local/bin
RUN java --version && \
    fossa --version

CMD ["fossa"]
