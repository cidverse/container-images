# platforms=linux/amd64,linux/arm64
# image=quay.io/cidverse/githubcli

# build
#
FROM registry.hub.docker.com/library/golang:1.19 AS builder

# renovate: datasource=github-releases depName=cli/cli
ARG GITHUBCLI_VERSION=2.14.6

RUN apt-get update && \
    apt-get install -y unzip && \
    mkdir -p /cache && \
    curl -L -o /cache/githubcli-v${GITHUBCLI_VERSION}.zip https://github.com/cli/cli/archive/refs/tags/v${GITHUBCLI_VERSION}.zip && \
    unzip /cache/githubcli-v${GITHUBCLI_VERSION}.zip -d /tmp/src && \
    cd /tmp/src/cli-${GITHUBCLI_VERSION} && \
    go build -o /usr/local/bin/gh -ldflags "-s -w" /tmp/src/cli-${GITHUBCLI_VERSION}/cmd/gh

# runtime image
#
FROM quay.io/cidverse/base-ubi:latest

COPY --from=builder /usr/local/bin/gh /usr/local/bin/gh

USER 1001
CMD ["gh"]
