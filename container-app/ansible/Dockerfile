# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/ansible

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.0.0-1687 AS builder

# renovate: datasource=pypi depName=ansible
ARG ANSIBLE_VERSION=6.6.0

# renovate: datasource=pypi depName=docker
ARG DOCKER_VERSION=6.0.1

RUN pkg-install python3-pip ca-certificates && \
    pkg-install-rootfs python3 sshpass && \
    pip3 install --upgrade pip && \
    pip3 install --root="/rootfs" --no-warn-script-location ansible==${ANSIBLE_VERSION} && \
    pip3 install --root="/rootfs" --no-warn-script-location docker==${DOCKER_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.0.0-24
COPY --from=builder /rootfs /
RUN mkdir -p /app/.ansible && \
    chmod -R 777 /app/.ansible

USER 1001
CMD ["ansible"]
