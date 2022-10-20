# platforms=linux/amd64
# image=quay.io/cidverse/twitchcli

# compile the twitch cli binary
# 
FROM registry.hub.docker.com/library/golang:1.19 AS builder

# renovate: datasource=github-releases depName=twitchdev/twitch-cli
ARG TWITCHCLI_VERSION=1.1.10
ARG TARGETOS
ARG TARGETARCH

RUN apt-get update \
&&  apt-get install -y --no-install-recommends unzip \
&&  mkdir -p /cache \
&&  curl -L -o /cache/twitchcli-${TWITCHCLI_VERSION}.zip https://github.com/twitchdev/twitch-cli/archive/refs/tags/v${TWITCHCLI_VERSION}.zip \
&&  unzip /cache/twitchcli-${TWITCHCLI_VERSION}.zip -d /tmp/twitchcli-src \
&&  cd /tmp/twitchcli-src/twitch-cli-${TWITCHCLI_VERSION} \
&&  CGO_ENABLED=1 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /usr/local/bin/twitch -ldflags "-s -w -X main.buildVersion=${TWITCHCLI_VERSION}" . \
&&  rm -rf /var/lib/apt/lists/*

# runtime image
#
FROM quay.io/cidverse/base-ubi:latest

COPY --from=builder /usr/local/bin/twitch /usr/local/bin/twitch
RUN twitch mock-api generate -c 15

USER 1001
CMD ["twitch"]
