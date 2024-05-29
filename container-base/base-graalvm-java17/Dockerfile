# platforms=linux/amd64
# image=quay.io/cidverse/base-graalvm-java17
# tag-regex=ARG GRAALVM_VERSION=vm-(?P<major>[0-9]+)\.(?P<minor>[0-9]+)\.(?P<patch>[0-9]+)

# build
#
FROM quay.io/cidverse/base-ubi-build:9.4-949.1716471857 AS builder

# renovate: datasource=github-releases depName=graalvm/graalvm-ce-builds
ARG GRAALVM_VERSION=vm-22.3.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs zlib-devel && \
    export FILE_NAME=$(curl -s https://api.github.com/repos/graalvm/graalvm-ce-builds/releases/tags/${GRAALVM_VERSION} | jq -r ".assets[] | select((.name | endswith(\".tar.gz\") and contains(\"graalvm-ce-java17-${TARGETOS}-${TARGETARCH}\"))) | .name") && \
    export FILE_DOWNLOAD=$(curl -s https://api.github.com/repos/graalvm/graalvm-ce-builds/releases/tags/${GRAALVM_VERSION} | jq -r ".assets[] | select((.name | endswith(\".tar.gz\") and contains(\"graalvm-ce-java17-${TARGETOS}-${TARGETARCH}\"))) | .browser_download_url") && \
    file-download "/cache/${FILE_NAME}" "${FILE_DOWNLOAD}" && \
    file-download "/cache/${FILE_NAME}.sha256" "${FILE_DOWNLOAD}.sha256" && \
    tar -xf "/cache/${FILE_NAME}" -C /tmp && \
    mkdir -p /usr/lib/graalvm && \
    mv /tmp/graalvm-*/* /usr/lib/graalvm

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-6.1716471860

COPY --from=builder /rootfs /
COPY --from=builder /usr/lib/graalvm /usr/lib/graalvm

ENV JAVA_HOME=/usr/lib/graalvm
ENV PATH="${PATH}:/usr/lib/graalvm/bin"
RUN java -version

CMD ["java"]
