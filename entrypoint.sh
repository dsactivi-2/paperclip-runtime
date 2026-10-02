#!/bin/sh
set -eu

mkdir -p "${PAPERCLIP_HOME:-/paperclip}"
cd "${PAPERCLIP_HOME:-/paperclip}"

# Idempotent. Uses DATABASE_URL when it is set, otherwise embedded Postgres.
exec paperclipai onboard --yes
