# Container Images for CI-Usage

This is a collection of container images mostly for ci/cd usage.

All container images aim to to `micro` images, this means:

- no package manager
- bash (required by some ci tools)
- the actual application
- supported for a wide range of architectures

We also provide a minimal and build image, which should be used in a multi stage builds to first compile/download/verify and then finally move the final artifacts into the `micro` image.

## Base Images

| Image          | Arch                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| common-micro   | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/amd64&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/arm64/v8&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/s390x&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/ppc64le&message=✓&color=success) |
| common-minimal | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/amd64&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/arm64/v8&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/s390x&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/ppc64le&message=✓&color=success) |
| common-build   | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/amd64&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/arm64/v8&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/s390x&message=✓&color=success) ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/ppc64le&message=✓&color=success) |

TODO: Need another suitable base image similar to UBI-MICRO to supported ARCHs that are missing in UBI.

## App Images

> The provided ARCHs are limited by the binaries from the upstream releases.

| Image                | amd64 | arm64 | s390x | ppc64le |
|----------------------|-------|-------|-------|---------|
| ansible              | ✓     | ✓     | ✗     | ✗       |
| applicationinspector | ✓     | ✓     | ✗     | ✗       |
| aws                  | ✓     | ✓     | ✗     | ✗       |
| buildah              | ✓     | ✗     | ✗     | ✗       |
| codecov-upload       | ✓     | ✗     | ✗     | ✗       |
| cosign               | ✓     | ✓     | ✓     | ✓       |
| cue                  | ✓     | ✓     | ✗     | ✗       |
| fossacli             | ✓     | ✗     | ✗     | ✗       |
| ggshield             | ✓     | ✓     | ✗     | ✗       |
| githubcli            | ✓     | ✓     | ✗     | ✗       |
| gitleaks             | ✓     | ✓     | ✗     | ✗       |
| glab                 | ✓     | ✓     | ✗     | ✗       |
| grype                | ✓     | ✓     | ✗     | ✗       |
| hadolint             | ✓     | ✗     | ✗     | ✗       |
| helm                 | ✓     | ✓     | ✓     | ✓       |
| kubectl              | ✓     | ✓     | ✓     | ✓       |
| openshiftcli         | ✓     | ✗     | ✗     | ✗       |
| rke                  | ✓     | ✓     | ✗     | ✗       |
| s2i                  | ✓     | ✗     | ✗     | ✗       |
| shellcheck           | ✓     | ✓     | ✗     | ✗       |
| sonarscannercli      | ✓     | ✗     | ✗     | ✗       |
| syft                 | ✓     | ✓     | ✗     | ✓       |
| twitchcli            | ✓     | ✗     | ✗     | ✗       |
| upx                  | ✓     | ✓     | ✗     | ✓       |
