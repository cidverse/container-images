# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=ghcr.io/cidverse/base-ubi
# publish-version-arg=UBI_MICRO_VERSION

# ubi base versions (both ARGs must stay before the first FROM to remain in scope for all FROM lines)
# renovate: datasource=docker depName=registry.access.redhat.com/ubi10-micro
ARG UBI_MICRO_VERSION=10.2-1791441953
# renovate: datasource=docker depName=registry.access.redhat.com/ubi10-minimal
ARG UBI_MINIMAL_VERSION=10.2-1791346265

# ubi micro base
FROM registry.access.redhat.com/ubi10-micro:$UBI_MICRO_VERSION AS ubi-micro

# ubi minimal
FROM registry.access.redhat.com/ubi10-minimal:$UBI_MINIMAL_VERSION AS ubi-minimal

# image
FROM scratch
COPY --from=ubi-micro / /
COPY --from=ubi-minimal /etc/pki /etc/pki

# configuration
ENV HOME=/app
ENV LD_LIBRARY_PATH=/usr/local/lib:/lib64:/usr/lib64:$LD_LIBRARY_PATH
RUN mkdir -p /app && \
    chgrp -R 0 /app && \
    chmod -R 770 /app

# labels
LABEL org.opencontainers.image.base.name="registry.access.redhat.com/ubi10-micro"
LABEL org.opencontainers.image.base.digest=""
LABEL org.opencontainers.image.base.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

CMD ["/bin/bash"]
