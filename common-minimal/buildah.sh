#!/usr/bin/env bash

container=$(buildah from registry.access.redhat.com/ubi9-minimal:latest)
buildah config --label "-" $container
buildah config --env HOME=/app $container
buildah run $container useradd -u 1001 app --no-create-home --home-dir /app
buildah run $container mkdir -p /app
buildah run $container chgrp -R 0 /app
buildah run $container chmod -R g=u /app
buildah commit --format oci $container quay.io/cidverse/common-minimal:latest
buildah push quay.io/cidverse/common-minimal:latest
