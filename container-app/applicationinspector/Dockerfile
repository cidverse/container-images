# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/applicationinspector

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.0.0-1644 as builder

# renovate: datasource=github-releases depName=microsoft/ApplicationInspector
ARG APPINSPECTOR_VERSION=1.6.23

RUN pkg-install dotnet-sdk-6.0 && \
    dotnet tool install --global Microsoft.CST.ApplicationInspector.CLI --version ${APPINSPECTOR_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-dotnet-runtime:6.0

COPY --from=builder /app/.dotnet /app/.dotnet
RUN mkdir -p /app/.ansible && \
    chmod -R 777 /app/.ansible

USER 1001
CMD ["appinspector"]
