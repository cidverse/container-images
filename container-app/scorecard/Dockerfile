# platforms=linux/amd64
# image=quay.io/cidverse/scorecard

# build
#
FROM quay.io/cidverse/base-ubi-build:9.4-1194 AS builder

# renovate: datasource=github-releases depName=ossf/scorecard
ARG SCORECARD_VERSION=5.0.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN file-download "/cache/scorecard_${SCORECARD_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" "https://github.com/ossf/scorecard/releases/download/v${SCORECARD_VERSION}/scorecard_${SCORECARD_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" && \
    tar xzvf "/cache/scorecard_${SCORECARD_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" -C /tmp/ && \
    mv /tmp/scorecard-${TARGETOS}-${TARGETARCH} /usr/local/bin/scorecard && \
    chmod +x /usr/local/bin/scorecard

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-13

COPY --from=builder /usr/local/bin/scorecard /usr/local/bin/scorecard
RUN scorecard version

CMD ["scorecard"]
