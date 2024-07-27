# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-temurin-jdk-11
# tag-regex=ARG ADOPTIUM_VERSION=jdk-(?P<major>[0-9]+)\.(?P<minor>[0-9]+)\.(?P<patch>[0-9]+)\+(?P<build>[0-9]+)

# build
#
FROM quay.io/cidverse/base-ubi-build:9.4-1134 AS builder

# renovate: datasource=github-releases depName=adoptium/temurin11-binaries
ARG ADOPTIUM_VERSION=jdk-11.0.17+8
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs zlib-devel && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=aarch64; fi && \
    export DL_URL=$(curl -s https://api.github.com/repos/adoptium/temurin11-binaries/releases/tags/${ADOPTIUM_VERSION} | jq -r ".assets[] | select((.name | endswith(\".tar.gz\") and contains(\"OpenJDK11U-jdk_${TARGETARCH}_${TARGETOS}_hotspot\"))) | .browser_download_url") && \
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
FROM quay.io/cidverse/base-ubi:9.4-13

COPY --from=builder /rootfs /
COPY --from=builder /usr/lib/jvm/temurin /usr/lib/jvm/temurin
ADD scripts/* /usr/local/bin/

ENV JAVA_HOME=/usr/lib/jvm/temurin
ENV PATH="${PATH}:/usr/lib/jvm/temurin/bin"
RUN java -version

CMD ["java"]
