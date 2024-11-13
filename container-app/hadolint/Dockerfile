# platforms=linux/amd64
# image=quay.io/cidverse/hadolint

# build
#
FROM quay.io/cidverse/base-ubi-build:9.5-1730489338 AS builder

# renovate: datasource=github-releases depName=hadolint/hadolint
ARG HADOLINT_VERSION=2.12.0
ARG TARGETOS
ARG TARGETARCH

RUN curl -L -o /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 && \
    chmod +x /usr/local/bin/hadolint

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.5-1730497698

COPY --from=builder /usr/local/bin/hadolint /usr/local/bin/hadolint

CMD ["hadolint"]
