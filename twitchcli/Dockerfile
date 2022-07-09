# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64,linux/arm64
# image=quay.io/cidverse/twitchcli

# compile the twitch cli binary
# 
FROM registry.hub.docker.com/library/golang:1.18

# renovate: datasource=github-releases depName=twitchdev/twitch-cli
ARG TWITCHCLI_VERSION=1.1.6
ARG TARGETOS
ARG TARGETARCH

RUN apt-get update \
&&  apt-get install -y curl unzip \
&&  mkdir -p /tmp/download \
&&  curl -L -o /tmp/download/twitchcli-${TWITCHCLI_VERSION}.zip https://github.com/twitchdev/twitch-cli/archive/refs/tags/v${TWITCHCLI_VERSION}.zip \
&&  unzip /tmp/download/twitchcli-${TWITCHCLI_VERSION}.zip -d /tmp/twitchcli-src \
&&  cd /tmp/twitchcli-src/twitch-cli-${TWITCHCLI_VERSION} \
&&  go install src.techknowlogick.com/xgo@latest \
&&  CGO_ENABLED=1 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /usr/local/bin/twitch -ldflags "-s -w -X main.buildVersion=${TWITCHCLI_VERSION}" .

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=0 /usr/local/bin/twitch /usr/local/bin/twitch

USER 1001
CMD ["twitch"]
