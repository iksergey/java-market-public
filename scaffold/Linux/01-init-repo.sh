#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib/render.sh"
source "$HERE/lib/config.sh"

target="$(pwd)"
if [[ -n "$(ls -A "$target" | grep -v -x -e .git -e .DS_Store)" ]]; then
  die "папка $target не пуста — скрипт создаёт проект только с нуля"
fi

load_config "$HERE/scaffold.conf"
default_package="$BASE_PKG"
while true; do
  printf 'Базовый Java-пакет [%s] (Enter — оставить): ' "$default_package"
  read -r chosen_package || die "не удалось прочитать базовый пакет — запустите скрипт в терминале"
  chosen_package="${chosen_package:-$default_package}"
  if is_valid_package "$chosen_package"; then
    BASE_PKG="$chosen_package"
    break
  fi
  echo "Некорректное имя пакета. Пример: com.example.foo" >&2
done

printf 'BASE_PACKAGE=%s\n' "$BASE_PKG" > "$target/scaffold.conf"
echo "Создаю структуру проекта в $target"
render_tree "$HERE/templates/repo" "$target" "project=Java Marketplace" "basepkg=$BASE_PKG"

cat <<MSG

Готово. Базовый пакет $BASE_PKG сохранён в $target/scaffold.conf.
Добавление сервисов и библиотек из этой же папки:
  $HERE/02-add-catalog.sh
  $HERE/03-add-common-kernel.sh
  $HERE/04-add-basket.sh
  $HERE/05-add-promotion.sh
  $HERE/06-add-checkout.sh
  $HERE/07-add-common-messaging.sh
  $HERE/08-add-common-metrics.sh
MSG
