# image=quay.io/cidverse/buildah

# compile buildah from source
# 
FROM quay.io/cidverse/common-minimal:latest AS builder

# renovate: datasource=github-releases depName=containers/buildah
ARG BUILDAH_VERSION=1.26.2

RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    microdnf install -y containers-common device-mapper-devel golang gpgme-devel libassuan-devel libseccomp-devel make runc glibc-static git && \
    mkdir -p /go/src/github.com/containers && \
    git clone --depth 1 --branch v${BUILDAH_VERSION} https://github.com/containers/buildah.git /go/src/github.com/containers/buildah && \
    cd /go/src/github.com/containers/buildah && \
    env GOPATH=/go make -C /go/src/github.com/containers/buildah clean all install

# config source
#
FROM quay.io/buildah/stable:v1.26.2 AS config

# runtime image
#
FROM quay.io/cidverse/common-minimal:latest

COPY --from=builder /usr/local/bin/buildah /usr/local/bin/buildah
COPY --from=config /etc/containers /etc/containers
ADD script/buildah-script /usr/local/bin/buildah-script

# containers-common runc
RUN microdnf install -y fuse-overlayfs && \
    sed -i -r -e 's,driver = ".*",driver = "vfs",g' /etc/containers/storage.conf && \
    mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock

# uid/gid ranges for the user - https://github.com/containers/buildah/issues/3053
RUN echo -e "app:1:999\napp:1001:64535" > /etc/subuid && \
    echo -e "app:1:999\napp:1001:64535" > /etc/subgid && \
    mkdir -p /app/.local/share/containers /app/.config && \
    chmod -R 777 /etc/containers /app/.config /app/.local/share/containers
ENV BUILDAH_ISOLATION chroot

VOLUME /var/lib/containers
VOLUME /app/.local/share/containers
USER root
CMD ["buildah"]
