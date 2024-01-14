# platforms=linux/amd64,linux/arm64/v8
# image=quay.io/cidverse/aws

# build
#
FROM quay.io/cidverse/base-ubi-build:9.3-1361.1699548032 AS builder

# renovate: datasource=github-releases depName=aws/aws-cli
ARG AWS_VERSION=2.7.19
ARG TARGETOS
ARG TARGETARCH

RUN pkg-install-rootfs groff-base less zlib && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/amd64" ]; then export TARGETARCH=x86_64; fi && \
    if [ "$TARGETOS/$TARGETARCH" == "linux/arm64" ]; then export TARGETARCH=aarch64; fi && \
    file-download "/cache/awscli-exe-${TARGETOS}-${TARGETARCH}-${AWS_VERSION}.zip" "https://awscli.amazonaws.com/awscli-exe-${TARGETOS}-${TARGETARCH}-${AWS_VERSION}.zip" && \
    unzip -q "/cache/awscli-exe-${TARGETOS}-${TARGETARCH}-${AWS_VERSION}.zip" -d /tmp

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-9

COPY --from=builder /rootfs /
COPY --from=builder /tmp/aws /tmp/aws
RUN /tmp/aws/install && \
    rm -rf /tmp/aws && \
    aws --version

CMD ["aws"]
