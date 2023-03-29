# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/ggshield

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1793 AS builder

# renovate: datasource=pypi depName=ggshield
ARG GGSHIELD_VERSION=1.14.5

RUN pkg-install python3-pip ca-certificates && \
    pkg-install-rootfs python3 git && \
    pip3 install --root="/rootfs" --no-warn-script-location ggshield==${GGSHIELD_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-15

COPY --from=builder /rootfs /

CMD ["ggshield"]
