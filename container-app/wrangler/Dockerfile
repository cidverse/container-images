# platforms=linux/amd64
# image=quay.io/cidverse/wrangler

# runtime image
#
FROM quay.io/cidverse/base-node:23.4.0

# renovate: datasource=npm depName=wrangler
ARG WRANGLER_VERSION=4.12.0

RUN npm install -g wrangler@"${WRANGLER_VERSION}" && \
    wrangler --version
CMD ["wrangler"]
