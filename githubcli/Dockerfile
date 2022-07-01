# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64,linux/arm64
# image=quay.io/cidverse/githubcli

# compile the twitch cli binary
#
FROM registry.hub.docker.com/library/golang:1.17

# renovate: datasource=github-releases depName=cli/cli
ARG GITHUBCLI_VERSION=2.13.0

RUN apt-get update \
&&  apt-get install -y unzip \
&&  curl -L -o /tmp/src.zip https://github.com/cli/cli/archive/refs/tags/v${GITHUBCLI_VERSION}.zip \
&&  unzip /tmp/src.zip -d /tmp/src \
&&  cd /tmp/src/cli-${GITHUBCLI_VERSION} \
&&  go build -o /usr/local/bin/gh -ldflags "-s -w" /tmp/src/cli-${GITHUBCLI_VERSION}/cmd/gh

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=0 /usr/local/bin/gh /usr/local/bin/gh

USER 1001
CMD ["gh"]
