#!/bin/bash
set -e

# overwrite kubectl config file (useful for ci/cd)
if [ -n "$KUBECONFIG_CONTENT" ]; then
    echo $KUBECONFIG_CONTENT | base64 --decode > /app/.kube/config
fi

exec "$@"
