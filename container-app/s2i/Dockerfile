# platforms=linux/amd64
# image=quay.io/cidverse/s2i

# build
#
FROM quay.io/cidverse/base-ubi-build:9.3-1612 AS builder

# renovate: datasource=github-releases depName=openshift/source-to-image
ARG S2I_VERSION=1.3.9
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN export DL_URL=$(curl -s https://api.github.com/repos/openshift/source-to-image/releases/tags/v${S2I_VERSION} | jq -r '.assets[] | select((.name | contains("source-to-image")) and (.name | contains ("linux-amd64"))) | .browser_download_url') && \
    file-download "/cache/s2i-${S2I_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" "$DL_URL" && \
    tar xzvf "/cache/s2i-${S2I_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/s2i /usr/local/bin/s2i && \
    mv /tmp/sti /usr/local/bin/sti

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-15

COPY --from=builder /usr/local/bin/s2i /usr/local/bin/s2i
COPY --from=builder /usr/local/bin/sti /usr/local/bin/sti

CMD ["s2i"]
