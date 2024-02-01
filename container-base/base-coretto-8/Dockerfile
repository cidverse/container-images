# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-coretto-8

# build
#
FROM quay.io/cidverse/base-ubi-build:9.3-1552 AS builder

# renovate: datasource=github-releases depName=corretto/corretto-8
ARG CORETTO_VERSION=8.402.08.1
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=aarch64; fi && \
    file-download "/cache/amazon-corretto-${CORETTO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "https://corretto.aws/downloads/resources/${CORETTO_VERSION}/amazon-corretto-${CORETTO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" && \
    tar -xf "/cache/amazon-corretto-${CORETTO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp && \
    mkdir -p /usr/lib/jvm/coretto && \
    mv /tmp/amazon-corretto-${CORETTO_VERSION}-${TARGETOS}-${TARGETARCH}/* /usr/lib/jvm/coretto && \
    # gradle and maven wrapper needs these
    mkdir -p /rootfs/usr/bin && \
    cp /usr/bin/xargs /rootfs/usr/bin/xargs && \
    cp /usr/bin/sed /rootfs/usr/bin/sed

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-13

COPY --from=builder /rootfs /
COPY --from=builder /usr/lib/jvm/coretto /usr/lib/jvm/coretto
ADD scripts/* /usr/local/bin/

ENV JAVA_HOME=/usr/lib/jvm/coretto
ENV PATH="${PATH}:/usr/lib/jvm/coretto/bin"
RUN java -version

CMD ["java"]
