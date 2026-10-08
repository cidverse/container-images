# platforms=linux/amd64
# image=ghcr.io/cidverse/laya-cuda

# renovate: datasource=docker depName=ghcr.io/cidverse/base-ubi-build
ARG BASE_UBI_BUILD_VERSION=10.2-1790753097
# renovate: datasource=docker depName=ghcr.io/cidverse/base-ubi
ARG BASE_UBI_VERSION=10.2-1787684489
# renovate: datasource=github-releases depName=NandhaKishorM/laya
ARG APP_VERSION=0.4.1
FROM ghcr.io/cidverse/base-ubi-build:${BASE_UBI_BUILD_VERSION} AS build

ARG APP_VERSION
# renovate: datasource=pypi depName=torch
ARG TORCH_VERSION=2.14.1
ARG TORCH_INDEX=cu130

ENV PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1

# System packages needed to build/run the venv (gcc/make/git already in base-ubi-build).
# python3-devel is deliberately NOT installed: it lives in CodeReady Builder
# (needs a subscribed host), and laya is pure Python with prebuilt manylinux
# wheels for every dependency, so no compiler headers are required.
RUN microdnf install -y \
        python3.12 \
        python3.12-pip \
        libgomp \
    && microdnf clean all

RUN python3.12 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    VIRTUAL_ENV="/opt/venv"

# Install torch from the requested wheel index, verify it matches the index,
# then install laya[serve] from the exact upstream release tag.
RUN pip install --upgrade pip setuptools wheel \
    && pip install "torch==${TORCH_VERSION}" --index-url "https://download.pytorch.org/whl/${TORCH_INDEX}" \
    && git clone --depth 1 --branch "v${APP_VERSION}" https://github.com/NandhaKishorM/laya.git /src/laya \
    && python /src/laya/docker/check_torch.py "${TORCH_INDEX}" \
    && pip install "/src/laya[serve]" \
    && pip check

# App layout (mirrors upstream runtime stage): user, model cache, entrypoint, examples.
RUN groupadd --gid 10001 laya \
    && useradd --uid 10001 --gid laya --create-home --home-dir /home/laya laya \
    && mkdir -p /home/laya/.cache/huggingface /opt/laya/examples /usr/share/doc/laya \
    && chmod 777 /home/laya/.cache/huggingface \
    && cp -a /src/laya/docker/entrypoint.py /opt/laya/entrypoint.py \
    && cp -a /src/laya/examples/docker/. /opt/laya/examples/ \
    && cp -a /src/laya/LICENSE /usr/share/doc/laya/LICENSE

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

LABEL org.opencontainers.image.title="Laya (CUDA)" \
      org.opencontainers.image.source="https://github.com/NandhaKishorM/laya" \
      org.opencontainers.image.licenses="Apache-2.0" \
      io.github.cidverse.component="laya-cuda"

COPY --from=build /runtime-root/ /
COPY --from=build /opt/venv /opt/venv
COPY --from=build /home/laya /home/laya
COPY --from=build /opt/laya /opt/laya
COPY --from=build /usr/share/doc/laya /usr/share/doc/laya

# torch 2.14 swaps some eager CUDA ops (bmm, topk, sum, norms) for Triton kernels
# compiled on first inference, which needs a C compiler this image does not
# carry; the stock kernels give the same answers at the same latency (upstream #365).
ENV PATH="/opt/venv/bin:$PATH" \
    VIRTUAL_ENV="/opt/venv" \
    TORCH_DISABLE_NATIVE_JIT=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    USE_TF=0 \
    USE_TORCH=1 \
    TOKENIZERS_PARALLELISM=false \
    OMP_NUM_THREADS=4 \
    LAYA_DEVICE=cuda \
    LAYA_HOST=0.0.0.0 \
    LAYA_PORT=8000 \
    LAYA_MODEL=auto \
    LAYA_REQUEST_FILE=/opt/laya/examples/request.json \
    HF_HOME=/home/laya/.cache/huggingface \
    HF_HUB_OFFLINE=0 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility

RUN mkdir -p /home/laya/.cache/huggingface \
    && chmod -R 777 /home/laya/.cache/huggingface \
    && chgrp -R 0 /home/laya /opt/laya \
    && chmod -R g=u /home/laya /opt/laya

USER laya
WORKDIR /home/laya

EXPOSE 8000

ENTRYPOINT ["python", "/opt/laya/entrypoint.py"]
CMD ["laya-serve"]
