# platforms=linux/amd64,linux/arm64/v8,linux/s390x,linux/ppc64le
# image=quay.io/cidverse/techdocscli

# runtime image
#
FROM quay.io/cidverse/base-node:18.11.0

# renovate: datasource=npm depName=@techdocs/cli
ARG TECHDOCS_VERSION=1.2.1

USER root
RUN npm install -g --omit=dev @techdocs/cli@${TECHDOCS_VERSION}

USER 1001
RUN techdocs-cli --version
CMD ["techdocs-cli"]
