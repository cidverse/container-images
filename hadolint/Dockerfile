# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/hadolint

# build binary
# 
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=hadolint/hadolint
ARG HADOLINT_VERSION=2.10.0
ARG TARGETOS
ARG TARGETARCH

RUN curl -L -o /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
&&  chmod +x /usr/local/bin/hadolint

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/hadolint /usr/local/bin/hadolint

USER 1001
CMD ["hadolint"]
