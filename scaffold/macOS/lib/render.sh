#!/usr/bin/env bash

render_tree() {
  local tpl="$1" dst="$2"; shift 2
  local sed_expr=()
  local kv
  for kv in "$@"; do
    local key="${kv%%=*}" val="${kv#*=}"
    val="${val//|/\\|}"; val="${val//&/\\&}"
    sed_expr+=(-e "s|__${key}__|${val}|g")
  done

  local src rel out
  while IFS= read -r -d '' src; do
    rel="${src#"$tpl"/}"; rel="${rel%.tpl}"
    out="$dst/$(printf '%s' "$rel" | sed "${sed_expr[@]}")"
    mkdir -p "$(dirname "$out")"
    if is_binary "$src"; then
      cp "$src" "$out"
    else
      sed "${sed_expr[@]}" "$src" > "$out"
    fi
    [[ -x "$src" ]] && chmod +x "$out"
    echo "  + ${out#"$dst"/}"
  done < <(find "$tpl" -type f ! -name template.conf ! -name .DS_Store -print0 | sort -z)
}

is_binary() {
  ! grep -Iq . "$1" 2>/dev/null
}

capitalize() {
  printf '%s' "$(printf '%s' "${1:0:1}" | tr '[:lower:]' '[:upper:]')${1:1}"
}

die() { echo "ошибка: $*" >&2; exit 1; }
