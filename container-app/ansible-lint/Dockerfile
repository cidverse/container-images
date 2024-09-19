# platforms=linux/amd64
# image=quay.io/cidverse/ansible-lint

# build image
#
FROM quay.io/cidverse/build-python:3.12.3 AS builder

# renovate: datasource=pypi depName=ansible-lint
ARG ANSIBLELINT_VERSION=24.9.2

# renovate: datasource=pypi depName=rpds-py
ARG RPDSPY_VERSION=0.20.0

ENV PIPX_HOME=/app/.local/share/pipx
ENV PIPX_BIN_DIR=/app/.local/bin
ENV PIPX_DEFAULT_PYTHON=/usr/bin/python3
RUN pipx install --include-deps ansible-lint==${ANSIBLELINT_VERSION} && \
    pipx inject ansible-lint rpds-py==${RPDSPY_VERSION} && \
    pipx list

# runtime image
#
FROM quay.io/cidverse/base-python:3.12.3

COPY --from=builder /app /app

ENV PATH=/app/.local/bin:$PATH
RUN ansible-lint --version

CMD ["ansible-lint"]
