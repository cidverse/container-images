# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/fossacli

# runtime image
#
FROM quay.io/cidverse/common-minimal:latest
ENV HOME=/app

ARG TARGETOS
ARG TARGETARCH
# renovate: datasource=github-releases depName=fossas/fossa-cli
ARG FOSSACLI_VERSION=3.3.8

RUN microdnf install -y java-11-openjdk unzip \
&&  curl -H 'Cache-Control: no-cache' -L -o /tmp/fossa.zip https://github.com/fossas/fossa-cli/releases/download/v${FOSSACLI_VERSION}/fossa_${FOSSACLI_VERSION}_${TARGETOS}_${TARGETARCH}.zip \
&&  unzip /tmp/fossa.zip -d /tmp \
&&  cp /tmp/fossa /usr/local/bin/fossa \
&&  chmod +x /usr/local/bin/fossa \
&&  rm -rf /tmp/* \
&&  microdnf remove -y unzip

USER 1001
CMD ["fossa"]
