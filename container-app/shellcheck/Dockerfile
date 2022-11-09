# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/shellcheck

# build
#
FROM quay.io/cidverse/base-ubi-build:9.0.0-1700 AS builder

# renovate: datasource=github-releases depName=koalaman/shellcheck
ARG SHELLCHECK_VERSION=0.8.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x86_64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=aarch64; fi && \
    file-download "/cache/shellcheck-${TARGETOS}-${TARGETARCH}-${SHELLCHECK_VERSION}.tar.xz" "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.${TARGETOS}.${TARGETARCH}.tar.xz" && \
    tar -xvf "/cache/shellcheck-${TARGETOS}-${TARGETARCH}-${SHELLCHECK_VERSION}.tar.xz" -C /tmp && \
    cp /tmp/shellcheck-v${SHELLCHECK_VERSION}/shellcheck /usr/local/bin/shellcheck

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.0.0-23

COPY --from=builder /usr/local/bin/shellcheck /usr/local/bin/shellcheck
RUN shellcheck --version

USER 1001
CMD ["shellcheck"]
