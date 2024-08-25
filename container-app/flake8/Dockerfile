# platforms=linux/amd64
# image=quay.io/cidverse/flake8

# runtime image
#
FROM quay.io/cidverse/base-python:3.12.3

# renovate: datasource=pypi depName=flake8
ARG FLAKE8_VERSION=6.0.0

RUN python3 -m ensurepip --upgrade && \
    pip3 install --upgrade pip && \
    pip3 install flake8==${FLAKE8_VERSION} && \
    flake8 --version

ENV HOME /app
CMD ["flake8"]
