# platforms=linux/amd64
# image=quay.io/cidverse/renovate-config-validator

# runtime image
#
FROM quay.io/cidverse/base-node:23.4.0

# renovate: datasource=npm depName=renovate
ARG RENOVATE_VERSION=39.205.0

RUN npm install -g renovate@"${RENOVATE_VERSION}"

CMD ["renovate-config-validator"]
