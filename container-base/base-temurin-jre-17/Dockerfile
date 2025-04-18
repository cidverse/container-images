# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-temurin-jre-17
# tag-regex=ARG ADOPTIUM_VERSION=jdk-(?P<major>[0-9]+)\.(?P<minor>[0-9]+)\.(?P<patch>[0-9]+)\+(?P<build>[0-9]+)

# build
#
FROM quay.io/cidverse/base-ubi-build:9.5-1734497536 AS builder

# renovate: datasource=github-releases depName=adoptium/temurin17-binaries
ARG ADOPTIUM_VERSION=jdk-17.0.5+8
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs zlib-devel && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=aarch64; fi && \
    export DL_URL=$(curl -s https://api.github.com/repos/adoptium/temurin17-binaries/releases/tags/${ADOPTIUM_VERSION} | jq -r ".assets[] | select((.name | endswith(\".tar.gz\") and contains(\"OpenJDK17U-jre_${TARGETARCH}_${TARGETOS}_hotspot\"))) | .browser_download_url") && \
    file-download "/cache/temurin-jre-${ADOPTIUM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "$DL_URL" && \
    tar -xf "/cache/temurin-jre-${ADOPTIUM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp && \
    mkdir -p /usr/lib/jvm/temurin && \
    mv /tmp/*-jre/* /usr/lib/jvm/temurin

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.5-1734513256

COPY --from=builder /rootfs /
COPY --from=builder /usr/lib/jvm/temurin /usr/lib/jvm/temurin
ADD scripts/* /usr/local/bin/

ENV JAVA_HOME=/usr/lib/jvm/temurin
ENV PATH="${PATH}:/usr/lib/jvm/temurin/bin"
RUN chmod +x /usr/local/bin/* && \
    java --version

CMD ["java"]
