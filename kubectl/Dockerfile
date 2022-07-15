# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64
# image=quay.io/cidverse/kubectl

# build / download
# 
FROM quay.io/cidverse/common-build:latest

# renovate: datasource=github-releases depName=kubernetes/kubernetes
ARG K8S_VERSION=1.24.3
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -o /usr/local/bin/kubectl \
&&  chmod +x /usr/local/bin/kubectl

# runtime image
#
FROM quay.io/cidverse/common-micro:latest

RUN mkdir -p /app/.kube
ADD entrypoint.sh /app/entrypoint.sh
COPY --from=0 /usr/local/bin/kubectl /usr/local/bin/kubectl

USER 1001
ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD ["kubectl"]
VOLUME [ "/app/.kube" ]
