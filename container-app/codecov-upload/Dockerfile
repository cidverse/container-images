# platforms=linux/amd64
# image=quay.io/cidverse/codecov-upload

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.5-1734513256

# renovate: datasource=github-releases depName=codecov/uploader
ARG CODECOV_VERSION=0.8.0

ADD https://uploader.codecov.io/v${CODECOV_VERSION}/linux/codecov /usr/local/bin/codecov

CMD ["codecov"]
