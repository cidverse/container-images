# platforms=linux/amd64
# image=quay.io/cidverse/sarifrs

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.2-750 AS builder

# renovate: datasource=github-releases depName=psastras/sarif-rs
ARG SARIFRS_VERSION=0.4.0

RUN curl -L -o /usr/local/bin/shellcheck-sarif https://github.com/psastras/sarif-rs/releases/download/shellcheck-sarif-v${SARIFRS_VERSION}/shellcheck-sarif-x86_64-unknown-linux-gnu && \
    curl -L -o /usr/local/bin/sarif-fmt https://github.com/psastras/sarif-rs/releases/download/sarif-fmt-v${SARIFRS_VERSION}/sarif-fmt-x86_64-unknown-linux-gnu && \
    curl -L -o /usr/local/bin/hadolint-sarif https://github.com/psastras/sarif-rs/releases/download/hadolint-sarif-v${SARIFRS_VERSION}/hadolint-sarif-x86_64-unknown-linux-gnu && \
    curl -L -o /usr/local/bin/clippy-sarif https://github.com/psastras/sarif-rs/releases/download/clippy-sarif-v${SARIFRS_VERSION}/clippy-sarif-x86_64-unknown-linux-gnu && \
    curl -L -o /usr/local/bin/clang-tidy-sarif https://github.com/psastras/sarif-rs/releases/download/clang-tidy-sarif-v${SARIFRS_VERSION}/clang-tidy-sarif-x86_64-unknown-linux-gnu && \
    chmod +x /usr/local/bin/*


# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-6

COPY --from=builder /usr/local/bin/shellcheck-sarif /usr/local/bin/shellcheck-sarif
COPY --from=builder /usr/local/bin/sarif-fmt /usr/local/bin/sarif-fmt
COPY --from=builder /usr/local/bin/hadolint-sarif /usr/local/bin/hadolint-sarif
COPY --from=builder /usr/local/bin/clippy-sarif /usr/local/bin/clippy-sarif
COPY --from=builder /usr/local/bin/clang-tidy-sarif /usr/local/bin/clang-tidy-sarif

CMD ["sarif-fmt"]
