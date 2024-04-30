# platforms=linux/amd64
# image=quay.io/cidverse/sonarscannercli

# build
#
FROM quay.io/cidverse/base-ubi-build:9.3-1612 AS builder

# renovate: datasource=github-releases depName=SonarSource/sonar-scanner-cli
ARG SONARSCANNERCLI_VERSION=5.0.1.3006
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install-rootfs zlib.i686 git python3 java-11-openjdk-headless

RUN mkdir -p /cache /app/sonarscanner && \
    file-download "/cache/sonar-scanner-cli-${SONARSCANNERCLI_VERSION}-${TARGETOS}.zip" "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNERCLI_VERSION}-${TARGETOS}.zip" && \
    unzip /cache/sonar-scanner-cli-${SONARSCANNERCLI_VERSION}-${TARGETOS}.zip -d /tmp && \
    mv /tmp/sonar-scanner-${SONARSCANNERCLI_VERSION}-${TARGETOS}/* /app/sonarscanner

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-6
ENV PATH="${PATH}:/app/sonarscanner/bin" \
    JAVA_HOME=/usr/lib/jvm/jre-11-openjdk

COPY --from=builder /rootfs /
COPY --from=builder /app/sonarscanner /app/sonarscanner
RUN mkdir -p /app/.sonar /app/.sonar/cache /app/.sonar/cache/_tmp && \
    chmod -R 777 /app

ENV HOME=/app
ENV SONAR_USER_HOME=/app/.sonar
CMD ["sonar-scanner"]
