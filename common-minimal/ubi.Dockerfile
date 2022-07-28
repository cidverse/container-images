# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/common-minimal:latest

# upstream
FROM registry.access.redhat.com/ubi9-minimal:9.0.0-1580 AS ubi

# image
FROM scratch
COPY --from=ubi / /
ADD scripts/* /usr/local/bin
ADD config/dnf.conf /etc/dnf/dnf.conf

# configuration
ENV HOME=/app
RUN useradd -u 1001 app --no-create-home --home-dir /app \
&&  mkdir -p /app /cache \
&&  chgrp -R 0 /app \
&&  chmod -R g=u /app
CMD /bin/bash

# labels (only set information about the base layer do not mess with the app images labels)
LABEL org.opencontainers.image.base.name="registry.access.redhat.com/ubi9-minimal"
LABEL org.opencontainers.image.base.digest=""
LABEL org.opencontainers.image.base.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"
