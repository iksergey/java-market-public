#!/usr/bin/env bash

is_valid_package() {
  local package_pattern='^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*$'
  [[ "$1" =~ $package_pattern ]]
}

load_config() {
  local config="$1"
  [[ -r "$config" ]] || die "не найден или недоступен файл настроек: $config"

  BASE_PKG="$(sed -n 's/^[[:space:]]*BASE_PACKAGE[[:space:]]*=[[:space:]]*//p' "$config" | sed 's/[[:space:]]*$//')"
  is_valid_package "$BASE_PKG" || die "в $config задайте одну строку BASE_PACKAGE с именем пакета, например BASE_PACKAGE=com.example.foo"
}
