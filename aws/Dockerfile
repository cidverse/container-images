# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/aws

# compile the twitch cli binary
#
FROM quay.io/cidverse/common-build:latest AS builder

# renovate: datasource=github-releases depName=aws/aws-cli
ARG AWS_VERSION=2.7.19
ARG TARGETOS
ARG TARGETARCH

RUN pkg-install-rootfs groff-base less zlib

# linux/amd64
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then \
    file-download "/cache/awscli-exe-linux-x86_64-${AWS_VERSION}.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_VERSION}.zip" && \
    unzip -q "/cache/awscli-exe-linux-x86_64-${AWS_VERSION}.zip" -d /tmp \
    ; fi

# linux/arm64
RUN if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then \
    file-download "/cache/awscli-exe-linux-aarch64-${AWS_VERSION}.zip" "https://awscli.amazonaws.com/awscli-exe-linux-aarch64-${AWS_VERSION}.zip" && \
    unzip -q "/cache/awscli-exe-linux-aarch64-${AWS_VERSION}.zip" -d /tmp \
    ; fi

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

COPY --from=builder /rootfs /
COPY --from=builder /tmp/aws /tmp/aws
RUN /tmp/aws/install && \
    rm -rf /tmp/aws && \
    aws --version

USER 1001
CMD ["aws"]
