# platforms=linux/amd64
# image=quay.io/cidverse/minioclient

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.4-1134 AS builder

# renovate: datasource=github-releases depName=minio/mc
ARG MINIO_VERSION=2023.03.20
ARG MINIO_RELEASE="RELEASE.2023-03-20T17-17-53Z"
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# cidverse-download
RUN gpg --with-fingerprint --keyserver pgp.mit.edu --recv-keys 12C74390F9AAC728 && \
    file-download "/usr/local/bin/mc.${MINIO_RELEASE}" "https://dl.min.io/client/mc/release/${TARGETOS}-${TARGETARCH}/mc.${MINIO_RELEASE}" && \
    file-download "/usr/local/bin/mc.${MINIO_RELEASE}.asc" "https://dl.min.io/client/mc/release/${TARGETOS}-${TARGETARCH}/mc.${MINIO_RELEASE}.asc" && \
    file-download "/usr/local/bin/mc.${MINIO_RELEASE}.sha256sum" "https://dl.min.io/client/mc/release/${TARGETOS}-${TARGETARCH}/mc.${MINIO_RELEASE}.sha256sum" && \
    chmod +x /usr/local/bin/mc.${MINIO_RELEASE} && \
    mv /usr/local/bin/mc.${MINIO_RELEASE} /usr/local/bin/mc

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-13

COPY --from=builder /usr/local/bin/mc /usr/local/bin/mc
RUN mc --version

CMD ["mc"]
