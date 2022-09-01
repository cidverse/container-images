# platforms=linux/amd64
# image=quay.io/cidverse/codecov-upload

# runtime image
#
FROM quay.io/cidverse/base-ubi:latest

# renovate: datasource=github-releases depName=codecov/uploader
ARG CODECOV_VERSION=0.3.0

ADD https://uploader.codecov.io/v${CODECOV_VERSION}/linux/codecov /usr/local/bin/codecov

USER 1001
CMD ["codecov"]
