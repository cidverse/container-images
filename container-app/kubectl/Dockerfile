# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/kubectl

# build
#
FROM quay.io/cidverse/base-ubi-build:9.3-1552 AS builder

# renovate: datasource=github-releases depName=kubernetes/kubernetes
ARG K8S_VERSION=1.29.1
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.3-13

RUN mkdir -p /app/.kube
ADD entrypoint.sh /app/entrypoint.sh
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD ["kubectl"]
VOLUME [ "/app/.kube" ]
