# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-temurin-jdk-8
# tag-regex=ARG ADOPTIUM_VERSION=jdk(?P<major>[0-9]+)u(?P<minor>[0-9]+)-b[0]*(?P<patch>[0-9]+)

# build
#
FROM quay.io/cidverse/base-ubi-build:9.3-1361.1699548032 AS builder

# renovate: datasource=github-releases depName=adoptium/temurin8-binaries
ARG ADOPTIUM_VERSION=jdk8u392-b08
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=aarch64; fi && \
    export DL_URL=$(curl -s https://api.github.com/repos/adoptium/temurin8-binaries/releases/tags/${ADOPTIUM_VERSION} | jq -r ".assets[] | select((.name | endswith(\".tar.gz\") and contains(\"OpenJDK8U-jdk_${TARGETARCH}_${TARGETOS}_hotspot\"))) | .browser_download_url") && \
    file-download "/cache/temurin-jdk-${ADOPTIUM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "$DL_URL" && \
    tar -xf "/cache/temurin-jdk-${ADOPTIUM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp && \
    mkdir -p /usr/lib/jvm/temurin && \
    mv /tmp/$ADOPTIUM_VERSION/* /usr/lib/jvm/temurin && \
    # gradle and maven wrapper needs these
    mkdir -p /rootfs/usr/bin && \
    cp /usr/bin/xargs /rootfs/usr/bin/xargs && \
    cp /usr/bin/sed /rootfs/usr/bin/sed

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-6

COPY --from=builder /rootfs /
COPY --from=builder /usr/lib/jvm/temurin /usr/lib/jvm/temurin
ADD scripts/* /usr/local/bin/

ENV JAVA_HOME=/usr/lib/jvm/temurin
ENV PATH="${PATH}:/usr/lib/jvm/temurin/bin"
RUN java -version

CMD ["java"]
