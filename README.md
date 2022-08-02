# Container Images for CI-Usage

This is a collection of container images mostly for ci/cd usage.

All container images aim to to `micro` images, this means:

- no package manager
- bash (required by some ci tools)
- the actual application
- supported for a wide range of architectures

We also provide a minimal and build image, which should be used in a multi stage builds to first compile/download/verify and then finally move the final artifacts into the `micro` image.

## Base Images

> These images can be used as a base to build your own app images.

| Image           | amd64                                                                                                         | arm64                                                                                                            | s390x                                                                                                               | ppc64le                                                                                                               |
|-----------------|---------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| base-ubi        | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/amd64&message=⛳&color=success) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/arm64/v8&message=⛳&color=success) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/s390x&message=⛳&color=success)       | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/ppc64le&message=⛳&color=success)       |
| base-ubi-build  | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/amd64&message=⛳&color=success) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/arm64/v8&message=⛳&color=success) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/s390x&message=⛳&color=success)       | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/ppc64le&message=⛳&color=success)       |
| base-coretto-11 | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/amd64&message=⛳&color=success) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/arm64/v8&message=⛳&color=success) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/s390x&message=⛄&color=informational) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/ppc64le&message=⛄&color=informational) |
| base-coretto-17 | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/amd64&message=⛳&color=success) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/arm64/v8&message=⛳&color=success) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/s390x&message=⛄&color=informational) | ![](https://img.shields.io/static/v1?style=flat-square&logo=redhat&label=linux/ppc64le&message=⛄&color=informational) |

> Legend: Available: ⛳, 

## App Images

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
