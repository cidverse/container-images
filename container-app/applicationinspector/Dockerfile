# platforms=linux/amd64
# image=quay.io/cidverse/applicationinspector

# build image
#
FROM quay.io/cidverse/base-dotnet-sdk:9.0.100 as builder

# renovate: datasource=github-releases depName=microsoft/ApplicationInspector
ARG APPINSPECTOR_VERSION=1.9.36

RUN dotnet tool install --global Microsoft.CST.ApplicationInspector.CLI --version ${APPINSPECTOR_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-dotnet-runtime:9.0.0

COPY --from=builder /app/.dotnet/tools /usr/lib/dotnet/tools

CMD ["appinspector"]
RUN dotnet --info && \
    appinspector version || true
