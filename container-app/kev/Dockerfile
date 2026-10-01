# platforms=linux/amd64
# image=ghcr.io/cidverse/kev

# renovate: datasource=docker depName=ghcr.io/cidverse/base-ubi-build
ARG BASE_UBI_BUILD_VERSION=10.2-1790753097
# renovate: datasource=docker depName=ghcr.io/cidverse/base-ubi
ARG BASE_UBI_VERSION=10.2-1787684489
# Kev 1.0 release of https://github.com/jaredpalmer/kev (models pull at runtime,
# so the image version tracks the server release, not the weights).
ARG APP_VERSION=1.0
FROM ghcr.io/cidverse/base-ubi-build:${BASE_UBI_BUILD_VERSION} AS build

ARG APP_VERSION
# kev requires torch>=2.6,<2.9, so this stays on the 2.8 line (cu128 is the last
# index carrying it) even though newer torch exists. No renovate annotation on
# purpose: an automated bump past 2.9 would break the kev dependency resolver.
ARG TORCH_VERSION=2.8.0
ARG TORCH_INDEX=cu128
ARG KEV_REF=kev-1.0

ENV PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1

# System packages needed to build/run the venv (gcc/make/git already in base-ubi-build).
# python3-devel is deliberately NOT installed: it lives in CodeReady Builder
# (needs a subscribed host), and kev is pure Python with prebuilt manylinux
# wheels for every dependency, so no compiler headers are required.
RUN microdnf install -y \
        python3.12 \
        python3.12-pip \
        libgomp \
    && microdnf clean all

RUN python3.12 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    VIRTUAL_ENV="/opt/venv"

# torch first (from the CUDA wheel index), then kev[serve] from the pinned release.
# PyPI stays available as an extra index for kev's non-torch dependencies
# (e.g. typesafe-sdk); the already-installed torch satisfies kev's torch range.
RUN pip install --upgrade pip setuptools wheel \
    && pip install "torch==${TORCH_VERSION}" --index-url "https://download.pytorch.org/whl/${TORCH_INDEX}" \
    && pip install "kev[serve] @ git+https://github.com/jaredpalmer/kev.git@${KEV_REF}" \
        --index-url "https://download.pytorch.org/whl/${TORCH_INDEX}" \
        --extra-index-url "https://pypi.org/simple" \
    && pip check \
    && python -c "import kev.serve"

# Fused DeltaNet kernels for the Qwen3.5 models (4b/9b); optional - the server
# falls back to the pure-torch path without them, just slower.
RUN pip install flash-linear-attention \
    || echo "WARNING: flash-linear-attention unavailable for this torch/python combo, serving without fused kernels"

# App layout: user, model cache, entrypoint wrapper.
RUN groupadd --gid 10001 kev \
    && useradd --uid 10001 --gid kev --create-home --home-dir /home/kev kev \
    && mkdir -p /home/kev/.cache/huggingface /opt/kev \
    && chmod 777 /home/kev/.cache/huggingface \
    && printf '#!/bin/sh\nset -eu\nexec python -m kev.serve --run "${KEV_MODEL:-jaredpalmer/kev-4b}" --host "${KEV_HOST:-0.0.0.0}" --port "${KEV_PORT:-8008}" "$@"\n' > /opt/kev/entrypoint.sh \
    && chmod +x /opt/kev/entrypoint.sh

# Stage every system file the venv interpreter needs at runtime into /runtime-root.
# base-ubi (ubi-micro) has no package manager, so the runtime stage COPYs these over.
# NOTE: the walk must cover the interpreter AND every extension module (the stdlib's
# lib-dynload/*.so and the venv's own .so files): ldd on the python binary alone
# does not reveal libraries like libcrypto that only modules link against.
RUN set -euo pipefail; \
    dest=/runtime-root; mkdir -p "$dest"; \
    cp -a --parents /usr/bin/python3.12 "$dest/"; \
    r=$(realpath /usr/bin/python3.12); [ "$r" != /usr/bin/python3.12 ] && cp -a --parents "$r" "$dest/" || true; \
    ln -sf python3.12 "$dest/usr/bin/python3"; \
    ln -sf python3 "$dest/usr/bin/python"; \
    for d in /usr/lib/python3.12 /usr/lib64/python3.12 /usr/lib64/ossl-modules; do \
        [ -e "$d" ] && cp -a --parents "$d" "$dest/"; \
    done; \
    for f in /usr/lib64/libpython3.12.so*; do \
        [ -e "$f" ] && cp -a --parents "$f" "$dest/"; \
    done; \
    list=$(mktemp); \
    collect() { \
        for dep in $(ldd "$1" 2>/dev/null | grep -o '/[^ ]*' || true); do \
            case "$dep" in \
                /lib64/*) echo "/usr/lib64/${dep#/lib64/}";; \
                /lib/*) echo "/usr/lib/${dep#/lib/}";; \
                /bin/*) echo "/usr/bin/${dep#/bin/}";; \
                /sbin/*) echo "/usr/sbin/${dep#/sbin/}";; \
                *) echo "$dep";; \
            esac; \
        done; \
    }; \
    collect /usr/bin/python3.12 >> "$list"; \
    for so in /usr/lib64/python3.12/lib-dynload/*.so; do \
        [ -e "$so" ] && collect "$so" >> "$list"; \
    done; \
    while IFS= read -r so; do \
        collect "$so" >> "$list"; \
    done < <(find /opt/venv -name '*.so*' -type f 2>/dev/null); \
    sort -u "$list" | while IFS= read -r lib; do \
        case "$lib" in /usr/*) cp -aL --parents "$lib" "$dest/";; esac; \
    done; \
    sort -u "$list" | while IFS= read -r lib; do \
        case "$lib" in /usr/*) [ -e "$dest$lib" ] || { echo "ERROR: $lib not staged" >&2; exit 1; };; esac; \
    done; \
    rm -f "$list"; \
    cp -a --parents /etc/passwd /etc/group "$dest/"; \
    nf=$(mktemp); \
    for so in /usr/bin/python3.12 /usr/lib64/python3.12/lib-dynload/*.so; do \
        [ -e "$so" ] || continue; \
        ldd "$so" 2>/dev/null | grep 'not found' | sed "s|^|$so: |"; \
    done > "$nf" || true; \
    if grep -q . "$nf"; then \
        echo "ERROR: unresolved shared libraries in the python runtime:" >&2; \
        cat "$nf" >&2; \
        exit 1; \
    fi; \
    rm -f "$nf"; \
    vnf=$(mktemp); \
    find /opt/venv -name '*.so*' -type f 2>/dev/null | while IFS= read -r so; do \
        ldd "$so" 2>/dev/null | grep 'not found' || true; \
    done > "$vnf" || true; \
    if grep -q . "$vnf"; then \
        echo "NOTE: venv libs below are not resolvable by bare ldd (torch/nvidia plugin and cross-package libs resolve in torch's runtime load context):"; \
        grep -o '[[:alnum:]_+.-]*\.so\(\.[0-9]*\)* => not found' "$vnf" | sort | uniq -c || true; \
    fi; \
    rm -f "$vnf"

FROM ghcr.io/cidverse/base-ubi:${BASE_UBI_VERSION}

LABEL org.opencontainers.image.title="Kev decision-model server" \
      org.opencontainers.image.source="https://github.com/jaredpalmer/kev" \
      org.opencontainers.image.licenses="Apache-2.0" \
      io.github.cidverse.component="kev"

COPY --from=build /runtime-root/ /
COPY --from=build /opt/venv /opt/venv
COPY --from=build /home/kev /home/kev
COPY --from=build /opt/kev /opt/kev

ENV PATH="/opt/venv/bin:$PATH" \
    VIRTUAL_ENV="/opt/venv" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    TOKENIZERS_PARALLELISM=false \
    OMP_NUM_THREADS=4 \
    KEV_MODEL=jaredpalmer/kev-4b \
    KEV_HOST=0.0.0.0 \
    KEV_PORT=8008 \
    HF_HOME=/home/kev/.cache/huggingface \
    HF_HUB_OFFLINE=0

RUN mkdir -p /home/kev/.cache/huggingface \
    && chmod -R 777 /home/kev/.cache/huggingface \
    && chgrp -R 0 /home/kev /opt/kev \
    && chmod -R g=u /home/kev /opt/kev

USER kev
WORKDIR /home/kev

EXPOSE 8008

ENTRYPOINT ["/opt/kev/entrypoint.sh"]
