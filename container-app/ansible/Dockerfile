# platforms=linux/amd64
# image=quay.io/cidverse/ansible

# build image
#
FROM quay.io/cidverse/build-python:3.12.3 AS builder

# renovate: datasource=pypi depName=ansible
ARG ANSIBLE_VERSION=10.4.0

# renovate: datasource=pypi depName=docker
ARG DOCKER_VERSION=7.1.0

ENV PIPX_HOME=/app/.local/share/pipx
ENV PIPX_BIN_DIR=/app/.local/bin
ENV PIPX_DEFAULT_PYTHON=/usr/bin/python3
RUN pkg-install-rootfs sshpass && \
    pipx install --include-deps ansible==${ANSIBLE_VERSION} && \
    pipx inject ansible docker==${DOCKER_VERSION} && \
    pipx list

# runtime image
#
FROM quay.io/cidverse/base-python:3.12.3

COPY --from=builder /rootfs /
COPY --from=builder /app /app

ENV PATH=/app/.local/bin:$PATH
RUN mkdir -p /app/.ansible && \
    chmod -R 777 /app/.ansible && \
    ansible --version

CMD ["ansible"]
