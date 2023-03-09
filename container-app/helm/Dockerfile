# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/helm

# build
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1793 AS builder

# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=3.11.2
ARG TARGETOS=linux
ARG TARGETARCH=amd64

ENV HELM_RELEASE_REF=v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}
RUN curl https://get.helm.sh/KEYS | gpg --import && \
    file-download "/cache/helm-${HELM_RELEASE_REF}.tar.gz" "https://get.helm.sh/helm-${HELM_RELEASE_REF}.tar.gz" && \
    file-download "/cache/helm-${HELM_RELEASE_REF}.tar.gz.sha256sum" "https://get.helm.sh/helm-${HELM_RELEASE_REF}.tar.gz.sha256sum" && \
    file-download "/cache/helm-${HELM_RELEASE_REF}.tar.gz.asc" "https://github.com/helm/helm/releases/download/v${HELM_VERSION}/helm-${HELM_RELEASE_REF}.tar.gz.asc" && \
    tar -xf /cache/helm-${HELM_RELEASE_REF}.tar.gz -C /tmp && \
    mv /tmp/${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/helm

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-15

COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm

CMD ["helm"]
VOLUME [ "/app/.kube", "/app/.config/helm", "/app/.local/share/helm", "/app/.cache/helm" ]
