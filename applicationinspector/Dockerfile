# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/applicationinspector

# build image
#
FROM quay.io/cidverse/base-ubi-build:latest as builder

# renovate: datasource=github-releases depName=microsoft/ApplicationInspector
ARG APPINSPECTOR_VERSION=1.5.20

RUN pkg-install dotnet-sdk-6.0 && \
    pkg-install-rootfs dotnet-runtime-6.0 && \
    dotnet tool install --global Microsoft.CST.ApplicationInspector.CLI --version ${APPINSPECTOR_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-ubi:latest

COPY --from=builder /rootfs /
COPY --from=builder /app/.dotnet /app/.dotnet
ENV PATH="${PATH}:/app/.dotnet/tools"
RUN mkdir -p /app/.ansible && \
    chmod -R 777 /app/.ansible

USER 1001
CMD ["appinspector"]
