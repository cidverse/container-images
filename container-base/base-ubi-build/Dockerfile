# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/base-ubi-build:latest

# ubi minimal
FROM registry.access.redhat.com/ubi9-minimal:9.0.0-1644 AS ubi-minimal

# image
FROM scratch
COPY --from=ubi-minimal / /

# scripts
ADD scripts/* /usr/local/bin
ADD config/dnf.conf /etc/dnf/dnf.conf

# build utils
RUN pkg-install tar xz gzip unzip git gpg jq glibc-static make && \
    microdnf upgrade -y

# configuration
ENV HOME=/app
RUN useradd -u 1001 app --no-create-home --home-dir /app && \
    mkdir -p /app /cache && \
    chgrp -R 0 /app && \
    chmod -R 770 /app
CMD /bin/bash

# labels (only set information about the base layer do not mess with the app images labels)
LABEL org.opencontainers.image.base.name="registry.access.redhat.com/ubi9-minimal"
LABEL org.opencontainers.image.base.digest=""
LABEL org.opencontainers.image.base.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"
