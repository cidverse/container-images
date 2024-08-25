# platforms=linux/amd64
# image=quay.io/cidverse/pipenv

# runtime image
#
FROM quay.io/cidverse/base-python:3.12.3

# renovate: datasource=pypi depName=pipenv
ARG PIPENV_VERSION=2024.0.1

RUN python3 -m ensurepip --upgrade && \
    pip3 install pipenv==${PIPENV_VERSION} && \
    pipenv --version

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LC_CTYPE="en_US.UTF-8"

CMD ["pipenv"]
