# platforms=linux/amd64
# image=quay.io/cidverse/liquibase

# build binary
#
FROM quay.io/cidverse/base-ubi-build:9.2-691 AS builder

# renovate: datasource=github-releases depName=liquibase/liquibase
ARG LIQUIBASE_VERSION=4.22.0

RUN file-download "/cache/liquibase-${LIQUIBASE_VERSION}_${TARGETARCH}.tar.gz" https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz && \
    mkdir -p /tmp/liquibase && \
    tar -xzf "/cache/liquibase-${LIQUIBASE_VERSION}_${TARGETARCH}.tar.gz" -C /tmp/liquibase && \
    cp -R /tmp/liquibase /usr/lib/liquibase && \
    rm -rf /usr/lib/liquibase/examples

# runtime image
#
FROM quay.io/cidverse/base-coretto-17:17.0.7.7.1

COPY --from=builder /usr/lib/liquibase /usr/lib/liquibase
ENV PATH="${PATH}:/usr/lib/liquibase"
RUN liquibase --version

CMD ["liquibase"]
