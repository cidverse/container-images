# platforms=linux/amd64
# image=quay.io/cidverse/ggshield

# build image
#
FROM quay.io/cidverse/build-python:3.12.3 AS builder

# renovate: datasource=pypi depName=ggshield
ARG GGSHIELD_VERSION=1.31.0

ENV PIPX_HOME=/app/.local/share/pipx
ENV PIPX_BIN_DIR=/app/.local/bin
ENV PIPX_DEFAULT_PYTHON=/usr/bin/python3
RUN pkg-install-rootfs git && \
    pipx install --include-deps ggshield==${GGSHIELD_VERSION} && \
    pipx list

# runtime image
#
FROM quay.io/cidverse/base-python:3.12.3

COPY --from=builder /rootfs /
COPY --from=builder /app /app

ENV PATH=/app/.local/bin:$PATH
RUN ggshield --version

CMD ["ggshield"]
