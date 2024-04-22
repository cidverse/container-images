# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/base-dotnet-runtime

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.3-1612 as builder

# renovate: datasource=github-releases depName=dotnet/runtime
ARG DOTNET_RUNTIME_VERSION=8.0.4
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# pkg-install-rootfs dotnet-runtime-${DOTNET_RUNTIME_VERSION}
RUN pkg-install-rootfs libstdc++ krb5-libs libicu openssl-libs zlib && \
    file-download "/tmp/dotnet-install.sh" "https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh" && \
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh \
      --architecture "$TARGETARCH" \
      --install-dir "/usr/lib/dotnet" \
      --runtime "dotnet" \
      --version "$DOTNET_RUNTIME_VERSION" \
      --no-path

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-15

COPY --from=builder /rootfs /
COPY --from=builder /usr/lib/dotnet /usr/lib/dotnet

ENV PATH="${PATH}:/usr/lib/dotnet:/usr/lib/dotnet/tools"
ENV DOTNET_ROOT="/usr/lib/dotnet"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN dotnet --info
