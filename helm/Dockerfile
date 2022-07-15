# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64
# image=quay.io/cidverse/helm

# build / download
# 
FROM quay.io/cidverse/common-build:latest

# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=3.9.1
ARG TARGETOS=linux
ARG TARGETARCH=amd64

ENV HELM_RELEASE_REF=v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}
RUN curl https://get.helm.sh/KEYS | gpg --import \
&&  cidverse-download "helm-${HELM_RELEASE_REF}.tar.gz" "https://get.helm.sh/helm-${HELM_RELEASE_REF}.tar.gz" \
&&  cidverse-download "helm-${HELM_RELEASE_REF}.tar.gz.sha256sum" "https://get.helm.sh/helm-${HELM_RELEASE_REF}.tar.gz.sha256sum" \
&&  cidverse-download "helm-${HELM_RELEASE_REF}.tar.gz.asc" "https://github.com/helm/helm/releases/download/v${HELM_VERSION}/helm-${HELM_RELEASE_REF}.tar.gz.asc" \
&&  tar -xf /cache/helm-${HELM_RELEASE_REF}.tar.gz -C /tmp \
&&  mv /tmp/${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/helm

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=0 /usr/local/bin/helm /usr/local/bin/helm

RUN mkdir -p /app/.kube

USER 1001
CMD ["helm"]
VOLUME [ "/app/.kube", "/app/.config/helm", "/app/.local/share/helm", "/app/.cache/helm" ]
