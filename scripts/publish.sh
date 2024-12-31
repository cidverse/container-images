#!/usr/bin/env bash
set -euo pipefail

# arguments
imageName=$1
forceUpdate=false
if [[ "${2:-}" == "-f" ]]; then
    forceUpdate=true
fi

# build image
result=$(nix build .#${imageName}.image-amd64 --no-link --print-out-paths)

# query image metadata
name=$(skopeo inspect docker-archive:$result | jq -r '.Labels["io.github.cidverse.component"]')
version=$(skopeo inspect docker-archive:$result | jq -r '.Labels["io.github.cidverse.component-version"]')
os=$(skopeo inspect docker-archive:$result | jq -r '.Os')
arch=$(skopeo inspect docker-archive:$result | jq -r '.Architecture')

# push
if skopeo inspect --no-tags "docker://ghcr.io/cidverse/$name:$version" > /dev/null 2>&1 && [[ "$forceUpdate" == false ]]; then
    echo "[${imageName}] skipping cidverse/$name:$version - result: $result - already exists"
else
    echo "[${imageName}] pushing cidverse/$name:$version - result: $result"
    skopeo copy -f oci docker-archive:$result docker://ghcr.io/cidverse/$name:$version
    #skopeo copy -f oci docker-archive:$result docker://quay.io/cidverse/$name:$version
fi
