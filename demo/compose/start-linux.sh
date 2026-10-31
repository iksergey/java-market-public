#!/usr/bin/env bash
set -euo pipefail

compose_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed or is not in PATH." >&2
  exit 1
fi

if [ "$#" -eq 0 ]; then
  set -- up --detach --pull always --no-build
fi

exec docker compose --project-directory "$compose_dir" \
  -f "$compose_dir/compose.yaml" "$@"
