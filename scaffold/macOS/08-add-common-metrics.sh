#!/usr/bin/env bash
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/add-lib.sh" common-metrics metrics lib-plain
