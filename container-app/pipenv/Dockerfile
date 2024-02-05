# platforms=linux/amd64
# image=quay.io/cidverse/pipenv

# runtime image
#
FROM quay.io/cidverse/base-python:3.11.2

# renovate: datasource=pypi depName=pipenv
ARG PIPENV_VERSION=2023.12.1

RUN python3 -m ensurepip --upgrade && \
    pip3 install pipenv==${PIPENV_VERSION} && \
    pipenv --version

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LC_CTYPE="en_US.UTF-8"

CMD ["pipenv"]
