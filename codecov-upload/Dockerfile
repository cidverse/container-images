# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/codecov-upload

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

# renovate: datasource=github-releases depName=codecov/uploader
ARG CODECOV_VERSION=0.2.4

ADD https://uploader.codecov.io/v${CODECOV_VERSION}/linux/codecov /usr/local/bin/codecov

USER 1001
CMD ["codecov"]
