# platforms=linux/amd64
# image=quay.io/cidverse/openshiftcli

# build
#
FROM quay.io/cidverse/base-ubi-build:9.2-484 AS builder

# renovate: datasource=github-releases depName=openshift/okd
ARG OPENSHIFT_VERSION=4.10.0-0.okd-2022-07-09-073606
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN export DL_URL=$(curl -s https://api.github.com/repos/openshift/okd/releases/tags/${OPENSHIFT_VERSION} | jq -r '.assets[] | select(.name | contains("openshift-client-linux")) | .browser_download_url') && \
    file-download "/cache/oc-${OPENSHIFT_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "$DL_URL" && \
    tar xzvf "/cache/oc-${OPENSHIFT_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/oc /usr/local/bin

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.2-5

COPY --from=builder /usr/local/bin/oc /usr/local/bin/oc

CMD ["oc"]
VOLUME [ "/app/.kube" ]
