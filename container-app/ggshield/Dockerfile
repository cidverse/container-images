# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/ggshield

# build binary
#
FROM quay.io/cidverse/base-ubi-build:latest AS builder

# renovate: datasource=pypi depName=ggshield
ARG GGSHIELD_VERSION=1.13.5

RUN pkg-install python3-pip ca-certificates && \
    pkg-install-rootfs python3 git && \
    pip3 install --root="/rootfs" --no-warn-script-location ggshield==${GGSHIELD_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-ubi:latest

COPY --from=builder /rootfs /

USER 1001
CMD ["ggshield"]
