# platforms=linux/amd64
# image=quay.io/cidverse/reposync

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-13

# renovate: datasource=github-releases depName=cidverse/reposync
ARG REPOSYNC_VERSION=0.3.0

ADD https://github.com/cidverse/reposync/releases/download/v${REPOSYNC_VERSION}/linux_amd64 /usr/local/bin/reposync
RUN chmod +x /usr/local/bin/reposync && \
    reposync version

CMD ["reposync"]
