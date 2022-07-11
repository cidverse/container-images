# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64
# image=quay.io/cidverse/s2i

# build / download
# 
FROM quay.io/cidverse/common-build:latest

# renovate: datasource=github-releases depName=openshift/source-to-image
ARG S2I_VERSION=1.3.1
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN microdnf install -y jq \
&&  mkdir -p /cache \
&&  downloadUrl=$(curl -s https://api.github.com/repos/openshift/source-to-image/releases/tags/v${S2I_VERSION} | jq -r '.assets[] | select((.name | contains("source-to-image")) and (.name | contains ("linux-amd64"))) | .browser_download_url') \
&&  curl -L -o /cache/s2i-${S2I_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz $downloadUrl \
&&  tar xzvf /cache/s2i-${S2I_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -C /tmp/ \
&&  mv /tmp/s2i /usr/local/bin/s2i \
&&  mv /tmp/sti /usr/local/bin/sti

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=0 /usr/local/bin/s2i /usr/local/bin/s2i
COPY --from=0 /usr/local/bin/sti /usr/local/bin/sti

USER 1001
CMD ["s2i"]
