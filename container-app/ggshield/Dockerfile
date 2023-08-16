# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/ggshield

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.2-717 AS builder

# renovate: datasource=pypi depName=ggshield
ARG GGSHIELD_VERSION=1.18.0

RUN pkg-install python3-pip ca-certificates && \
    pkg-install-rootfs python3 git && \
    pip3 install --root="/rootfs" --no-warn-script-location ggshield==${GGSHIELD_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.2-13

COPY --from=builder /rootfs /

CMD ["ggshield"]
