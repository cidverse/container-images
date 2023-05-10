# platforms=linux/amd64
# image=quay.io/cidverse/runpodctl

# build
#
FROM quay.io/cidverse/base-ubi-build:9.2-484 AS builder

# renovate: datasource=github-releases depName=runpod/runpodctl
ARG RUNPODCTL_VERSION=1.10.0

RUN file-download /usr/local/bin/runpodctl https://github.com/runpod/runpodctl/releases/download/v${RUNPODCTL_VERSION}/runpodctl-linux-amd && \
    chmod +x /usr/local/bin/runpodctl

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.2-5

COPY --from=builder /usr/local/bin/runpodctl /usr/local/bin/runpodctl
RUN runpodctl version

CMD ["runpodctl"]
