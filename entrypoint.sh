#!/bin/sh
set -eu

home="${PAPERCLIP_HOME:-/paperclip}"
mkdir -p "$home"
config="$home/instances/default/config.json"

# `--yes` alone forces loopback. `--bind lan` keeps authenticated mode on 0.0.0.0.
# A previous quickstart config would keep binding to 127.0.0.1, which this host cannot route.
if [ -f "$config" ] && grep -q 'local_trusted' "$config"; then
  rm -f "$config"
fi

cd "$home"
export PAPERCLIP_NO_BROWSER=true
exec paperclipai onboard --yes --bind lan
