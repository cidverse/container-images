# platforms=linux/amd64
# image=quay.io/cidverse/runpodctl

# build
#
FROM quay.io/cidverse/base-ubi-build:9.4-949.1716471857 AS builder

# renovate: datasource=github-releases depName=runpod/runpodctl
ARG RUNPODCTL_VERSION=1.14.4

RUN file-download /usr/local/bin/runpodctl https://github.com/runpod/runpodctl/releases/download/v${RUNPODCTL_VERSION}/runpodctl-linux-amd64 && \
    chmod +x /usr/local/bin/runpodctl

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-9

COPY --from=builder /usr/local/bin/runpodctl /usr/local/bin/runpodctl
RUN runpodctl version

CMD ["runpodctl"]
