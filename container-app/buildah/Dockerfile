# image=quay.io/cidverse/buildah

###
# Notes
#
# - containers-common provides the config files in /etc/containers
###

# build image
# 
FROM quay.io/cidverse/build-go:1.21.4 AS builder

# renovate: datasource=github-releases depName=containers/buildah
ARG BUILDAH_VERSION=1.35.3

# bats, btrfs-progs-devel go-md2man
RUN pkg-install device-mapper-devel glib2-devel gpgme-devel libassuan-devel libseccomp-devel bzip2 runc skopeo-containers && \
    pkg-install-rootfs containers-common buildah && \
    mkdir -p /go/src/github.com/containers && \
    git clone --depth 1 --branch v${BUILDAH_VERSION} https://github.com/containers/buildah.git /go/src/github.com/containers/buildah && \
    cd /go/src/github.com/containers/buildah && \
    env GOPATH=/go make -C /go/src/github.com/containers/buildah clean bin/buildah && \
    cp /go/src/github.com/containers/buildah/bin/buildah /usr/local/bin/buildah

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-15

COPY --from=builder /rootfs /
COPY --from=builder /usr/local/bin/buildah /usr/local/bin/buildah
ADD script/buildah-script /usr/local/bin/buildah-script
ADD script/buildah-entrypoint.sh /usr/local/bin/buildah-entrypoint.sh

# containers-common runc
RUN sed -i -r -e 's,driver = ".*",driver = "vfs",g' /etc/containers/storage.conf && \
    mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock

# uid/gid ranges for the user - https://github.com/containers/buildah/issues/3053
RUN echo -e "app:1:999\napp:1001:64535" > /etc/subuid && \
    echo -e "app:1:999\napp:1001:64535" > /etc/subgid && \
    mkdir -p /app/.local/share/containers /app/.config /app/.auth && \
    chmod -R 777 /etc/containers /app/.config /app/.auth /app/.local/share/containers && \
    touch /app/.auth/auth.json
ENV BUILDAH_ISOLATION chroot
ENV REGISTRY_AUTH_FILE /app/.docker/config.json

VOLUME /var/lib/containers
VOLUME /app/.local/share/containers

USER root
ENTRYPOINT ["/bin/bash", "/usr/local/bin/buildah-entrypoint.sh"]
CMD ["buildah"]
