# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64
# image=quay.io/cidverse/openshiftcli

# build / download
# 
FROM quay.io/cidverse/common-build:latest

# renovate: datasource=github-releases depName=openshift/okd
ARG OPENSHIFT_VERSION=4.10.0-0.okd-2022-07-09-073606
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN export DL_URL=$(curl -s https://api.github.com/repos/openshift/okd/releases/tags/${OPENSHIFT_VERSION} | jq -r '.assets[] | select(.name | contains("openshift-client-linux")) | .browser_download_url') \
&&  cidverse-download "oc-${OPENSHIFT_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "$DL_URL" \
&&  tar xzvf "/cache/oc-${OPENSHIFT_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp/ \
&&  mv /tmp/oc /usr/local/bin

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=0 /usr/local/bin/oc /usr/local/bin/oc

USER 1001
CMD ["oc"]
VOLUME [ "/app/.kube" ]
