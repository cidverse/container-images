# platforms=linux/amd64
# image=quay.io/cidverse/quartz

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.5-1730489338 AS builder

ARG QUARTZ_VERSION=4.0.0

RUN pkg-install git && \
    git clone --branch v4 --depth 1 https://github.com/jackyzha0/quartz.git /app/quartz

# runtime image
#
FROM quay.io/cidverse/base-node:22.9.0
COPY --from=builder /app/quartz /app/quartz
ENV PATH="${PATH}:/app/quartz"

RUN cd /app/quartz && npm install && \
    echo -e '#!/usr/bin/env sh\nnpx quartz "$@"' > /usr/local/bin/quartz && \
    chmod +x /usr/local/bin/quartz && \
    echo "quartz version: $(/usr/local/bin/quartz --version)"
CMD ["quartz"]
