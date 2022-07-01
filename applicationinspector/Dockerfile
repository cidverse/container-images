# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/applicationinspector

# runtime image
#
FROM quay.io/cidverse/common-minimal:latest
ENV PATH="${PATH}:/app/.dotnet/tools"

# renovate: datasource=github-releases depName=microsoft/ApplicationInspector
ARG APPINSPECTOR_VERSION=1.5.13

RUN --mount=type=cache,target=/root/.local/share/NuGet/v3-cache \
    microdnf install dotnet-sdk-6.0 \
&&  dotnet tool install --global Microsoft.CST.ApplicationInspector.CLI --version ${APPINSPECTOR_VERSION} \
&&  microdnf remove dotnet-sdk-6.0 \
&&  microdnf install dotnet-runtime-6.0

USER 1001
CMD ["appinspector"]
