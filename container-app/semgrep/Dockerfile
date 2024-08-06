# platforms=linux/amd64
# image=quay.io/cidverse/semgrep

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.4-1194 AS builder

RUN pkg-install-rootfs git

# pip image
#
FROM quay.io/cidverse/base-python:3.11.2 AS pip

# renovate: datasource=pypi depName=semgrep
ARG SEMGREP_VERSION=1.84.0

RUN python3 -m ensurepip --upgrade && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install --root /rootfs --no-cache-dir --force-reinstall semgrep==${SEMGREP_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-python:3.11.2

COPY --from=builder /rootfs /
COPY --from=pip /rootfs /

RUN semgrep --version

CMD ["semgrep"]
