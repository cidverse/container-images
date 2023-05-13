# platforms=linux/amd64
# image=quay.io/cidverse/poetry

# runtime image
#
FROM quay.io/cidverse/base-python:3.9.16

# renovate: datasource=pypi depName=poetry
ARG POETRY_VERSION=1.4.2

RUN python3 -m ensurepip --upgrade && \
    pip3 install --upgrade pip && \
    pip3 install poetry==${POETRY_VERSION} && \
    poetry --version

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LC_CTYPE="en_US.UTF-8"

CMD ["poetry"]
