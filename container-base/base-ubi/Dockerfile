# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/base-ubi

# ubi micro base
# renovate: datasource=docker depName=registry.access.redhat.com/ubi9-micro
ARG UBI_BASE_VERSION=9.1.0-17
FROM registry.access.redhat.com/ubi9-micro:$UBI_BASE_VERSION AS ubi-micro

# ubi minimal
FROM registry.access.redhat.com/ubi9-minimal:9.2-484 AS ubi-minimal

# image
FROM scratch
COPY --from=ubi-micro / /
COPY --from=ubi-minimal /etc/pki /etc/pki

# configuration
ENV HOME=/app
RUN mkdir -p /app && \
    chgrp -R 0 /app && \
    chmod -R 770 /app
CMD /bin/bash

# labels (only set information about the base layer do not mess with the app images labels)
LABEL org.opencontainers.image.base.name="registry.access.redhat.com/ubi9-micro"
LABEL org.opencontainers.image.base.digest=""
LABEL org.opencontainers.image.base.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"
