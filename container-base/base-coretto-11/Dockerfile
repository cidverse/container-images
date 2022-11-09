# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-coretto-11

# build
#
FROM quay.io/cidverse/base-ubi-build:9.0.0-1700 AS builder

# renovate: datasource=github-releases depName=corretto/corretto-11
ARG CORETTO_VERSION=11.0.17.8.1
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=aarch64; fi && \
    file-download "/cache/amazon-corretto-${CORETTO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "https://corretto.aws/downloads/resources/${CORETTO_VERSION}/amazon-corretto-${CORETTO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" && \
    tar -xf "/cache/amazon-corretto-${CORETTO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp && \
    mkdir -p /usr/lib/jvm/coretto && \
    mv /tmp/amazon-corretto-${CORETTO_VERSION}-${TARGETOS}-${TARGETARCH}/* /usr/lib/jvm/coretto

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.0.0-23

COPY --from=builder /usr/lib/jvm/coretto /usr/lib/jvm/coretto
ENV JAVA_HOME=/usr/lib/jvm/coretto
ENV PATH="${PATH}:/usr/lib/jvm/coretto/bin"
RUN java --version

USER 1001
CMD ["java"]
