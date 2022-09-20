# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/base-ubi:latest

# ubi micro
FROM registry.access.redhat.com/ubi9-micro:9.0.0-21 AS ubi-micro

# ubi minimal
FROM registry.access.redhat.com/ubi9-minimal:9.0.0-1608 AS ubi-minimal

# image
FROM scratch
COPY --from=ubi-micro / /
COPY --from=ubi-minimal /etc/pki/ca-trust /etc/pki/ca-trust

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
