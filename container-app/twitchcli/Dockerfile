# platforms=linux/amd64
# image=quay.io/cidverse/twitchcli

# compile the twitch cli binary
# 
FROM quay.io/cidverse/build-go:1.21.0 AS builder

# renovate: datasource=github-releases depName=twitchdev/twitch-cli
ARG TWITCHCLI_VERSION=1.1.22
ARG TARGETOS
ARG TARGETARCH

RUN mkdir -p /cache && \
    curl -L -o /cache/twitchcli-${TWITCHCLI_VERSION}.zip https://github.com/twitchdev/twitch-cli/archive/refs/tags/v${TWITCHCLI_VERSION}.zip && \
    unzip /cache/twitchcli-${TWITCHCLI_VERSION}.zip -d /tmp/twitchcli-src && \
    cd /tmp/twitchcli-src/twitch-cli-${TWITCHCLI_VERSION} && \
    CGO_ENABLED=1 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /usr/local/bin/twitch -ldflags "-s -w -X main.buildVersion=${TWITCHCLI_VERSION}" .

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-6

COPY --from=builder /usr/local/bin/twitch /usr/local/bin/twitch
RUN twitch mock-api generate -c 15

CMD ["twitch"]
