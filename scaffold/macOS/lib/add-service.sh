#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$HERE/lib/render.sh"
source "$HERE/lib/config.sh"

BOOT_VERSION="4.1.1"
JAVA_VERSION="25"

name="$1"; arch="$2"
repo="$(pwd)"
load_config "$repo/scaffold.conf"
tpl="$HERE/templates/service-$arch"
[[ -d "$tpl" ]] || die "нет шаблона '$arch'"
[[ -d "$repo/src/services" ]] || die "в текущей папке нет src/services — сначала 01-init-repo.sh"
dst="$repo/src/services/$name"
[[ -e "$dst" ]] && die "сервис уже существует: $dst"

port="$(sed -n 's/^port=//p' "$tpl/template.conf")"
pkg="$(sed -n 's/^pkg=//p' "$tpl/template.conf")"; pkg="${pkg//__name__/$name}"
Name="$(capitalize "$name")"
vars=("name=$name" "Name=$Name" "pkg=$pkg" "port=$port" "basepkg=$BASE_PKG"
      "basepkgpath=${BASE_PKG//.//}" "bootversion=$BOOT_VERSION" "javaversion=$JAVA_VERSION")

echo "Создаю сервис $Name ($arch, порт $port, пакет $BASE_PKG.$pkg) в src/services/$name"
render_tree "$HERE/templates/service-common" "$dst" "${vars[@]}"
render_tree "$HERE/templates/gradle-wrapper" "$dst" "${vars[@]}"
render_tree "$tpl" "$dst" "${vars[@]}"
rm -f "$repo/src/services/.gitkeep"

if [[ -d "$dst/$name-api" ]]; then task=":$name-api:bootRun"; else task="bootRun"; fi
if [[ -n "$(find "$dst" -name HelloController.java)" ]]; then
  check="curl http://localhost:$port/hello"
else
  check="в логе — «Started ${Name}Application»"
fi
cat <<MSG

Готово. Проверка:
  cd src/services/$name && ./gradlew $task
  $check
MSG
