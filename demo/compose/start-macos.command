#!/usr/bin/env bash
set -euo pipefail

compose_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

exec bash "$compose_dir/start-linux.sh" "$@"
