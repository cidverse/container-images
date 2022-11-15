# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-dotnet-runtime

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.0.0-1700 as builder

ARG DOTNET_RUNTIME_VERSION=6.0

RUN pkg-install-rootfs dotnet-runtime-${DOTNET_RUNTIME_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-6

COPY --from=builder /rootfs /
ENV PATH="${PATH}:/app/.dotnet/tools"
