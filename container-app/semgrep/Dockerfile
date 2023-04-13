# platforms=linux/amd64
# image=quay.io/cidverse/semgrep

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1829 AS builder

RUN pkg-install-rootfs git

# runtime image
#
FROM quay.io/cidverse/base-python:3.9.14
COPY --from=builder /rootfs /

# renovate: datasource=pypi depName=semgrep
ARG SEMGREP_VERSION=1.17.1

RUN python3 -m ensurepip --upgrade && \
    pip3 install --upgrade pip && \
    pip3 install semgrep==${SEMGREP_VERSION} && \
    semgrep --version

ENV HOME /app
ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LC_CTYPE="en_US.UTF-8"

CMD ["semgrep"]
