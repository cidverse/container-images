# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/shellcheck

# build
#
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=koalaman/shellcheck
ARG SHELLCHECK_VERSION=0.8.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# linux/amd64
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then \
    file-download "/cache/shellcheck-linux-x86_64-${SHELLCHECK_VERSION}.tar.xz" "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" && \
    tar -xvf "/cache/shellcheck-linux-x86_64-${SHELLCHECK_VERSION}.tar.xz" -C /tmp && \
    cp /tmp/shellcheck-v${SHELLCHECK_VERSION}/shellcheck /usr/local/bin/shellcheck \
    ; fi

# linux/arm64
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then \
    file-download "/cache/shellcheck-linux-aarch64-${SHELLCHECK_VERSION}.tar.xz" "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.aarch64.tar.xz" && \
    tar -xvf "/cache/shellcheck-linux-aarch64-${SHELLCHECK_VERSION}.tar.xz" -C /tmp && \
    cp /tmp/shellcheck-v${SHELLCHECK_VERSION}/shellcheck /usr/local/bin/shellcheck \
    ; fi

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /usr/local/bin/shellcheck /usr/local/bin/shellcheck
RUN shellcheck --version

USER 1001
CMD ["shellcheck"]
