# platforms=linux/amd64
# image=quay.io/cidverse/fossacli

# runtime image
#
FROM quay.io/cidverse/common-minimal:latest

ARG TARGETOS
ARG TARGETARCH
# renovate: datasource=github-releases depName=fossas/fossa-cli
ARG FOSSACLI_VERSION=3.3.11

RUN microdnf install -y java-11-openjdk-headless unzip \
&&  curl -H 'Cache-Control: no-cache' -L -o /tmp/fossa.zip https://github.com/fossas/fossa-cli/releases/download/v${FOSSACLI_VERSION}/fossa_${FOSSACLI_VERSION}_${TARGETOS}_${TARGETARCH}.zip \
&&  unzip /tmp/fossa.zip -d /tmp \
&&  cp /tmp/fossa /usr/local/bin/fossa \
&&  chmod +x /usr/local/bin/fossa \
&&  rm -rf /tmp/* \
&&  microdnf remove -y unzip

ENV JAVA_HOME=/usr/lib/jvm/jre-11-openjdk

USER 1001
CMD ["fossa"]
