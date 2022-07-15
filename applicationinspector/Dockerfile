# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/applicationinspector

# runtime image
#
FROM quay.io/cidverse/common-minimal:latest
ENV PATH="${PATH}:/app/.dotnet/tools"

# renovate: datasource=github-releases depName=microsoft/ApplicationInspector
ARG APPINSPECTOR_VERSION=1.5.18

RUN microdnf install -y dotnet-sdk-6.0 \
&&  dotnet tool install --global Microsoft.CST.ApplicationInspector.CLI --version ${APPINSPECTOR_VERSION} \
&&  microdnf remove -y dotnet-sdk-6.0 \
&&  microdnf install -y dotnet-runtime-6.0

USER 1001
CMD ["appinspector"]
