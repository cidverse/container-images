# platforms=linux/amd64
# image=quay.io/cidverse/sonarscannercli

# build
#
FROM quay.io/cidverse/base-ubi-build:9.0.0-1644 AS builder

# renovate: datasource=github-releases depName=SonarSource/sonar-scanner-cli
ARG SONARSCANNERCLI_VERSION=4.7.0.2747
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs zlib.i686 git python3 java-11-openjdk-headless

RUN mkdir -p /cache /app/sonarscanner && \
    file-download "/cache/sonar-scanner-cli-${SONARSCANNERCLI_VERSION}-${TARGETOS}.zip" "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNERCLI_VERSION}-${TARGETOS}.zip" && \
    unzip /cache/sonar-scanner-cli-${SONARSCANNERCLI_VERSION}-${TARGETOS}.zip -d /tmp && \
    mv /tmp/sonar-scanner-${SONARSCANNERCLI_VERSION}-${TARGETOS}/* /app/sonarscanner

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.0.0-21
ENV PATH="${PATH}:/app/sonarscanner/bin" \
    JAVA_HOME=/usr/lib/jvm/jre-11-openjdk

COPY --from=builder /rootfs /
COPY --from=builder /app/sonarscanner /app/sonarscanner
RUN mkdir -p /app/.sonar && \
    chmod -R 777 /app

USER root
CMD ["sonar-scanner"]
