# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/buildah

# renovate: datasource=github-releases depName=containers/buildah
ARG BUILDAH_VERSION=1.26.2

# runtime image
#
FROM quay.io/buildah/stable:v1.26.0

ADD script/buildah-script /usr/local/bin/buildah-script

USER 1001
CMD ["buildah"]
