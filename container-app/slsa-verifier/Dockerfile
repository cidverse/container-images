# platforms=linux/amd64
# image=quay.io/cidverse/slsa-verifier

# build
#
FROM quay.io/cidverse/base-ubi-build:9.5-1734497536 AS builder

# renovate: datasource=github-releases depName=slsa-framework/slsa-verifier
ARG SLSAVERIFIER_VERSION=2.7.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN file-download "/usr/local/bin/slsa-verifier" "https://github.com/slsa-framework/slsa-verifier/releases/download/v${SLSAVERIFIER_VERSION}/slsa-verifier-${TARGETOS}-${TARGETARCH}" && \
    chmod +x /usr/local/bin/slsa-verifier

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.5-1734513256

COPY --from=builder /usr/local/bin/slsa-verifier /usr/local/bin/slsa-verifier
RUN slsa-verifier version

CMD ["slsa-verifier"]
