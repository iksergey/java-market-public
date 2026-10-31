#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$HERE/lib/render.sh"
source "$HERE/lib/config.sh"

BOOT_VERSION="4.1.1"
JAVA_VERSION="25"

name="$1"; pkg="$2"; template="${3:-lib-common}"
repo="$(pwd)"
load_config "$repo/scaffold.conf"
[[ -d "$repo/src/shared" ]] || die "в текущей папке нет src/shared — сначала 01-init-repo.sh"
dst="$repo/src/shared/$name"
[[ -e "$dst" ]] && die "библиотека уже существует: $dst"

vars=("name=$name" "pkg=$pkg" "basepkg=$BASE_PKG" "basepkgpath=${BASE_PKG//.//}"
      "bootversion=$BOOT_VERSION" "javaversion=$JAVA_VERSION")

echo "Создаю библиотеку $name (пакет $BASE_PKG.$pkg) в src/shared/$name"
render_tree "$HERE/templates/service-common" "$dst" "${vars[@]}"
rm -f "$dst/lombok.config"
render_tree "$HERE/templates/gradle-wrapper" "$dst" "${vars[@]}"
render_tree "$HERE/templates/$template" "$dst" "${vars[@]}"
mkdir -p "$dst/src/main/java/${BASE_PKG//.//}/$pkg"
rm -f "$repo/src/shared/.gitkeep"

cat <<MSG

Готово. Подключение в сервисе: includeBuild("../../shared/$name") в settings.gradle.kts
и implementation("$BASE_PKG:$name:0.0.1-SNAPSHOT") в build.gradle.kts.
MSG
