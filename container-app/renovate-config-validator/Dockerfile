# platforms=linux/amd64
# image=quay.io/cidverse/renovate-config-validator

# runtime image
#
FROM quay.io/cidverse/base-node:23.2.0

# renovate: datasource=npm depName=renovate
ARG RENOVATE_VERSION=39.49.3

RUN npm install -g renovate@"${RENOVATE_VERSION}"

CMD ["renovate-config-validator"]
