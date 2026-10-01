#!/usr/bin/env bash
set -euo pipefail

# arguments
imageName=$1
forceUpdate=false
if [[ "${2:-}" == "-f" ]]; then
    forceUpdate=true
fi

# always run from the repo root (this script lives in <root>/scripts/)
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# registries
registries=(
  "ghcr.io/cidverse"
  "registry.gitlab.com/cidverse/container-images"
  #"quay.io/cidverse"
)

# ------------------------------------------------------------
# Dockerfile-based images
#
# If container-app/<name>/Dockerfile (or container-base/<name>/Dockerfile)
# exists, the image is built with podman and pushed through the same
# registries loop as nix-built images.
#
# Conventions inside the Dockerfile:
#   version:  `ARG APP_VERSION=<version>`
#             (override per image with a `# publish-version-arg=<ARG>` header,
#              used by the ubi base images whose tag follows the pinned UBI version)
#   name:     `# image=ghcr.io/cidverse/<name>` header, else the directory name
#   platform: $PLATFORM, else first entry of the `# platforms=` header, else linux/amd64
# ------------------------------------------------------------

dockerfile=""
for candidate in "container-app/${imageName}/Dockerfile" "container-base/${imageName}/Dockerfile"; do
  if [[ -f "$candidate" ]]; then
    dockerfile="$candidate"
    break
  fi
done

if [[ -n "$dockerfile" ]]; then
  echo "Dockerfile-based image: ${dockerfile}"

  contextDir="$(dirname "$dockerfile")"

  name="$(sed -nE 's|^# image=ghcr\.io/cidverse/([^[:space:]]+).*|\1|p' "$dockerfile" | head -n 1)"
  name="${name:-$imageName}"

  versionArg="$(sed -nE 's|^# publish-version-arg=([^[:space:]]+).*|\1|p' "$dockerfile" | head -n 1)"
  versionArg="${versionArg:-APP_VERSION}"
  version="$(sed -nE "s|^ARG ${versionArg}=[\"']?([^\"'[:space:]]+).*|\1|p" "$dockerfile" | head -n 1)"
  if [[ -z "${version:-}" ]]; then
    echo "ERROR: no 'ARG ${versionArg}=<version>' found in ${dockerfile}" >&2
    exit 1
  fi

  platforms="$(sed -nE 's|^# platforms=(.*)|\1|p' "$dockerfile" | head -n 1 | tr -d '[:space:]')"
  platform="${PLATFORM:-${platforms%%,*}}"
  platform="${platform:-linux/amd64}"

  echo "Building ${name}:${version} for ${platform}..."

  # build (repeatable --platform flags so comma-separated PLATFORM values work)
  localRef="localhost/cidverse-${name}:${version}"
  platformFlags=()
  IFS=',' read -ra platformList <<< "$platform"
  for p in "${platformList[@]}"; do
    platformFlags+=(--platform "$p")
  done
  podman build "${platformFlags[@]}" --pull -f "$dockerfile" -t "$localRef" "$contextDir"

  # push to registries
  for registry in "${registries[@]}"; do
    imageRef="$registry/$name:$version"

    if skopeo inspect --no-tags "docker://$imageRef" > /dev/null 2>&1 && [[ "$forceUpdate" == false ]]; then
      echo "[${imageRef}] skipping - already exists"
    else
      echo "[${imageRef}] pushing - ${localRef}"
      podman push "$localRef" "$imageRef"
      echo "[${imageRef}] pushed"
    fi
  done

  exit 0
fi

# ------------------------------------------------------------
# nix-built images
# ------------------------------------------------------------

# build image
result=$(nix build .#${imageName}.image-amd64 --no-link --print-out-paths --show-trace)

# query image metadata
name=$(skopeo inspect docker-archive:$result | jq -r '.Labels["io.github.cidverse.component"]')
version=$(skopeo inspect docker-archive:$result | jq -r '.Labels["io.github.cidverse.component-version"]')
os=$(skopeo inspect docker-archive:$result | jq -r '.Os')
arch=$(skopeo inspect docker-archive:$result | jq -r '.Architecture')

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
