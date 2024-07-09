# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/helmfile

# build
#
FROM quay.io/cidverse/base-ubi-build:9.3-1612 AS builder

# renovate: datasource=github-releases depName=helmfile/helmfile
ARG HELMFILE_VERSION=0.166.0

# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=3.15.2

ARG TARGETOS=linux
ARG TARGETARCH=amd64

ENV HELM_RELEASE_REF=v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}
RUN curl https://get.helm.sh/KEYS | gpg --import && \
    file-download "/cache/helm-${HELM_RELEASE_REF}.tar.gz" "https://get.helm.sh/helm-${HELM_RELEASE_REF}.tar.gz" && \
    file-download "/cache/helm-${HELM_RELEASE_REF}.tar.gz.sha256sum" "https://get.helm.sh/helm-${HELM_RELEASE_REF}.tar.gz.sha256sum" && \
    file-download "/cache/helm-${HELM_RELEASE_REF}.tar.gz.asc" "https://github.com/helm/helm/releases/download/v${HELM_VERSION}/helm-${HELM_RELEASE_REF}.tar.gz.asc" && \
    tar -xf /cache/helm-${HELM_RELEASE_REF}.tar.gz -C /tmp && \
    mv /tmp/${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/helm

ENV HELMFILE_RELEASE_REF=v${HELMFILE_VERSION}-${TARGETOS}-${TARGETARCH}
RUN file-download "/cache/helm-${HELMFILE_RELEASE_REF}.tar.gz" "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" && \
    tar -xf /cache/helm-${HELMFILE_RELEASE_REF}.tar.gz -C /tmp && \
    mv /tmp/helmfile /usr/local/bin/helmfile

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-6

COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/bin/helmfile /usr/local/bin/helmfile
RUN helm version && \
    helmfile --version

CMD ["helmfile"]
