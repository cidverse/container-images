# platforms=linux/amd64
# image=quay.io/cidverse/native-image
# tag-regex=ARG GRAALVM_VERSION=vm-(?P<major>[0-9]+)\.(?P<minor>[0-9]+)\.(?P<patch>[0-9]+)

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.5-1730489338 AS builder

# renovate: datasource=github-releases depName=graalvm/graalvm-ce-builds
ARG GRAALVM_VERSION=vm-22.3.0
ARG TARGETOS
ARG TARGETARCH

RUN pkg-install-rootfs gcc glibc-devel zlib-devel libstdc++-static

# runtime image
#
FROM quay.io/cidverse/base-graalvm-java17:22.3.0

COPY --from=builder /rootfs /

RUN gu install native-image

CMD ["native-image"]
