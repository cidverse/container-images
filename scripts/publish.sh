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

# registries
registries=(
  "ghcr.io/cidverse"
  "registry.gitlab.com/cidverse/container-images"
  #"quay.io/cidverse"
)

# Loop through registries and push if not present
for registry in "${registries[@]}"; do
  imageRef="$registry/$name:$version"

  if skopeo inspect --no-tags "docker://$imageRef" > /dev/null 2>&1 && [[ "$forceUpdate" == false ]]; then
    echo "[${imageRef}] skipping - already exists"
  else
    echo "[${imageRef}] pushing - result: $result"
    skopeo copy -f oci "docker-archive:$result" "docker://$imageRef"
  fi
done
