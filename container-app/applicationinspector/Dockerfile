# platforms=linux/amd64
# image=quay.io/cidverse/applicationinspector

# build image
#
FROM quay.io/cidverse/base-dotnet-sdk:7.0.101 as builder

# renovate: datasource=github-releases depName=microsoft/ApplicationInspector
ARG APPINSPECTOR_VERSION=1.6.25

RUN dotnet tool install --global Microsoft.CST.ApplicationInspector.CLI --version ${APPINSPECTOR_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-dotnet-runtime:7.0.0

COPY --from=builder /app/.dotnet/tools /usr/lib/dotnet/tools

USER 1001
CMD ["appinspector"]
RUN dotnet --info && \
    appinspector version || true
