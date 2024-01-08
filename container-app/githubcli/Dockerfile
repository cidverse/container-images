# platforms=linux/amd64
# image=quay.io/cidverse/githubcli

# build
#
FROM quay.io/cidverse/build-go:1.21.0 AS builder

# renovate: datasource=github-releases depName=cli/cli
ARG GITHUBCLI_VERSION=2.41.0

RUN pkg-install-rootfs git && \
    mkdir -p /cache && \
    curl -L -o /cache/githubcli-v${GITHUBCLI_VERSION}.zip https://github.com/cli/cli/archive/refs/tags/v${GITHUBCLI_VERSION}.zip && \
    unzip /cache/githubcli-v${GITHUBCLI_VERSION}.zip -d /tmp/src && \
    cd /tmp/src/cli-${GITHUBCLI_VERSION} && \
    go build -o /usr/local/bin/gh -ldflags "-s -w" /tmp/src/cli-${GITHUBCLI_VERSION}/cmd/gh

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-6

COPY --from=builder /rootfs /
COPY --from=builder /usr/local/bin/gh /usr/local/bin/gh

RUN git --version && \
    gh --version

CMD ["gh"]
