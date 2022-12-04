#!/usr/bin/env bash
set -e

# if file is empty
[ -s /app/.auth/auth.json ] || echo "{}" > /app/.auth/auth.json

# exec cmd
exec "$@"
