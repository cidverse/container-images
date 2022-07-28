# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/common-micro:latest

# upstream
FROM registry.access.redhat.com/ubi9-micro:9.0.0-14 AS ubi

# upstream
FROM registry.access.redhat.com/ubi9-minimal:9.0.0-1580 AS minimal

# image
FROM scratch
COPY --from=ubi / /
COPY --from=minimal /etc/pki/ca-trust /etc/pki/ca-trust

# configuration
ENV HOME=/app
RUN mkdir -p /app /cache \
&&  chgrp -R 0 /app \
&&  chmod -R g=u /app
CMD /bin/bash

# labels (only set information about the base layer do not mess with the app images labels)
LABEL org.opencontainers.image.base.name="registry.access.redhat.com/ubi9-micro"
LABEL org.opencontainers.image.base.digest=""
LABEL org.opencontainers.image.base.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"
