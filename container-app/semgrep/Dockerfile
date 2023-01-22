# platforms=linux/amd64
# image=quay.io/cidverse/semgrep

# runtime image
#
FROM quay.io/cidverse/base-python:3.9.14

# renovate: datasource=pypi depName=semgrep
ARG SEMGREP_VERSION=1.5.1

RUN python3 -m ensurepip --upgrade && \
    pip3 install --upgrade pip && \
    pip3 install semgrep==${SEMGREP_VERSION} && \
    semgrep --version

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LC_CTYPE="en_US.UTF-8"

CMD ["semgrep"]
