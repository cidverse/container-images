# platforms=linux/amd64
# image=quay.io/cidverse/base-python

# build image
#
FROM quay.io/cidverse/base-ubi-build:9.1.0-1656.1669627757 AS builder

# renovate: datasource=github-releases depName=python/cpython
ARG PYTHON_VERSION=3.11.0
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN pkg-install zlib-devel && \
    file-download "/cache/python-${PYTHON_VERSION}.tar.xz" "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz" && \
    tar -xf "/cache/python-${PYTHON_VERSION}.tar.xz" -C /tmp && \
    cd /tmp/Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations --prefix=/usr/lib/python && \
    make && \
    make install

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.1.0-6

COPY --from=builder /usr/lib/python /usr/lib/python
ENV PATH="${PATH}:/usr/lib/python/bin"
RUN python3 --version

CMD ["python3"]
