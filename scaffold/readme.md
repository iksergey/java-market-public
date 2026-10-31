# Подготовка проекта

Подготовка окружения: [установка JDK 25 и Gradle](jdk-gradle-install.md).

Выберите папку своей системы. Каждая папка самостоятельна: внутри находятся
восемь скриптов, `scaffold.conf`, вспомогательные функции и все шаблоны.

| Папка | Оболочка | Файлы |
|---|---|---|
| `macOS` | Bash | `.sh` |
| `Linux` | Bash | `.sh` |
| `Windows` | Windows PowerShell 5.1 или PowerShell 7 | `.ps1` |

Для генерации не нужны Java, Gradle или Docker. Для дальнейшей работы с проектом
понадобятся JDK 25 и Docker с Docker Compose. В Linux скрипты используют Bash
и обычные утилиты `find`, `sort`, `sed`, `grep`, `cp`, `mkdir`, `chmod`, `tr`.
В Windows генерация выполняется средствами PowerShell и .NET; Bash и WSL не нужны.

## Подготовка и запуск

Распакуйте `scaffold` и создайте рядом пустую папку проекта `java-shop`.
Все скрипты запускайте из корня создаваемого проекта. Они могут находиться
в другой папке; пути с пробелами заключайте в кавычки.
Выполняйте каждую команду отдельно. Переходите к следующему шагу после
завершения текущего и проверки результата.

### Linux

В терминале Bash создайте папку проекта, если она ещё не существует:

```bash
mkdir java-shop
```

Перейдите в неё:

```bash
cd java-shop
```

Создайте основу проекта:

```bash
bash ../scaffold/Linux/01-init-repo.sh
```

Добавьте каталог товаров:

```bash
bash ../scaffold/Linux/02-add-catalog.sh
```

На этапе общей библиотеки выполните отдельный шаг:

```bash
bash ../scaffold/Linux/03-add-common-kernel.sh
```

и т. д.

Запуск через `bash` не требует предварительно делать скрипты исполняемыми.
Сгенерированный `gradlew` получает право на исполнение автоматически.

### macOS

Создайте папку проекта, если она ещё не существует:

```bash
mkdir java-shop
```

Перейдите в неё:

```bash
cd java-shop
```

Создайте основу проекта:

```bash
bash ../scaffold/macOS/01-init-repo.sh
```

Добавьте каталог товаров:

```bash
bash ../scaffold/macOS/02-add-catalog.sh
```

На этапе общей библиотеки выполните отдельный шаг:

```bash
bash ../scaffold/macOS/03-add-common-kernel.sh
```

и т. д.

### Windows

Подробный маршрут с установкой JDK, сборкой и HTTP-проверкой:
[отдельный раздел для Windows](jdk-gradle-install.md#windows).

Каждый блок ниже — одна введённая команда с её выводом. Вводите только текст
после `>`; приглашение PowerShell и строки результата набирать не нужно.
В примерах папка проекта называется `java-shop`.

Откройте PowerShell в папке `project`. Внутри неё уже должна находиться
распакованная папка `scaffold`. Рядом со `scaffold` создайте пустую `java-shop`,
если она ещё не существует:

```text
PS C:\Users\i\Desktop\project> mkdir java-shop


    Каталог: C:\Users\i\Desktop\project


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        02.11.2026      2:52                java-shop
```

Теперь отдельно перейдите в неё:

```text
PS C:\Users\i\Desktop\project> cd .\java-shop\
PS C:\Users\i\Desktop\project\java-shop>
```

В примерах переход в папку выполняется командой `cd`. В PowerShell это
псевдоним полной команды `Set-Location`. Если `cd` не распознаётся или был
переопределён, используйте `Set-Location` с тем же путём. Например, вместо
`cd .\java-shop\` введите `Set-Location .\java-shop\`.

Если сообщение говорит, что папка не найдена, проверьте путь и текущую папку:
замена имени команды не исправляет неверный путь.
[Справка Microsoft о Set-Location и его псевдонимах](https://learn.microsoft.com/powershell/module/microsoft.powershell.management/set-location?view=powershell-5.1).

Если `java-shop` уже существует, пропустите создание папки. Не создавайте внутри
неё ещё одну `java-shop`.

Создайте основу проекта и выберите базовый Java-пакет:

```text
PS C:\Users\i\Desktop\project\java-shop> powershell.exe -NoProfile -ExecutionPolicy Bypass -File '..\scaffold\Windows\01-init-repo.ps1'
Базовый Java-пакет [ru.ksergey.marketplace] (Enter — оставить):
Создаю структуру проекта в C:\Users\i\Desktop\project\java-shop
  + .dockerignore
  + .editorconfig
  + .gitignore
  + .vscode/java-formatter.xml
  + .vscode/jdt.prefs
  + .vscode/settings.json
  + readme.md
  + src/services/.gitkeep
  + src/shared/.gitkeep

Готово. Базовый пакет ru.ksergey.marketplace сохранён в C:\Users\i\Desktop\project\java-shop\scaffold.conf.
Добавление сервисов и библиотек из этой же папки:
  & 'C:\Users\i\Desktop\project\scaffold\Windows\02-add-catalog.ps1'
  & 'C:\Users\i\Desktop\project\scaffold\Windows\03-add-common-kernel.ps1'
  & 'C:\Users\i\Desktop\project\scaffold\Windows\04-add-basket.ps1'
  & 'C:\Users\i\Desktop\project\scaffold\Windows\05-add-promotion.ps1'
  & 'C:\Users\i\Desktop\project\scaffold\Windows\06-add-checkout.ps1'
  & 'C:\Users\i\Desktop\project\scaffold\Windows\07-add-common-messaging.ps1'
  & 'C:\Users\i\Desktop\project\scaffold\Windows\08-add-common-metrics.ps1'
```

Список следующих скриптов в выводе — подсказки. Первый скрипт только
показывает их; каждый следующий шаг запускайте отдельной командой.

Добавьте каталог товаров:

```text
PS C:\Users\i\Desktop\project\java-shop> powershell.exe -NoProfile -ExecutionPolicy Bypass -File '..\scaffold\Windows\02-add-catalog.ps1'
Создаю сервис Catalog (layered, порт 8181, пакет ru.ksergey.marketplace.catalog) в src/services/catalog
  + gradle.properties
  + lombok.config
  + gradle/wrapper/gradle-wrapper.jar
  + gradle/wrapper/gradle-wrapper.properties
  + gradle/wrapper/LICENSE
  + gradle/wrapper/NOTICE
  + gradlew
  + gradlew.bat
  + catalog-api/build.gradle.kts
  + catalog-api/src/main/java/ru/ksergey/marketplace/catalog/CatalogApplication.java
  + catalog-api/src/main/java/ru/ksergey/marketplace/catalog/HelloController.java
  + catalog-api/src/main/java/ru/ksergey/marketplace/catalog/web/package-info.java
  + catalog-api/src/main/resources/application.yaml
  + catalog-application/build.gradle.kts
  + catalog-application/src/main/java/ru/ksergey/marketplace/catalog/application/package-info.java
  + catalog-domain/build.gradle.kts
  + catalog-domain/src/main/java/ru/ksergey/marketplace/catalog/domain/model/package-info.java
  + catalog-domain/src/main/java/ru/ksergey/marketplace/catalog/domain/repository/package-info.java
  + catalog-infrastructure/build.gradle.kts
  + catalog-infrastructure/src/main/java/ru/ksergey/marketplace/catalog/infrastructure/package-info.java
  + build.gradle.kts
  + settings.gradle.kts

Готово. Проверка:
  Set-Location src/services/catalog
  .\gradlew.bat :catalog-api:bootRun
  Invoke-RestMethod http://localhost:8181/hello
PS C:\Users\i\Desktop\project\java-shop>
```

На этапе общей библиотеки запустите третий скрипт отдельно:

```text
PS C:\Users\i\Desktop\project\java-shop> powershell.exe -NoProfile -ExecutionPolicy Bypass -File '..\scaffold\Windows\03-add-common-kernel.ps1'
```

Он создаёт `src\shared\common-kernel`. Параметр `-ExecutionPolicy Bypass`
действует только на запущенный процесс и не изменяет постоянную политику
системы. После установки JDK перезапустите PowerShell; для встроенного
терминала полностью перезапустите VS Code.

## Базовый пакет

Первый скрипт спросит базовый Java-пакет, например `com.example.marketplace`.
Enter оставляет значение по умолчанию из `scaffold.conf` рядом со скриптами.
Некорректное значение можно ввести повторно.

Выбранное значение сохраняется в `scaffold.conf` в корне проекта. Последующие
шаги читают только этот файл и используют его для Java-пакетов, путей папок,
Gradle-группы и зависимостей на общие библиотеки. Сохраняйте файл вместе с
проектом и не меняйте пакет между шагами генерации.

## Порядок шагов

| Шаг | Имя без расширения | Результат |
|---|---|---|
| 01 | `01-init-repo` | Настройки проекта, README, `src/services` и `src/shared` |
| 02 | `02-add-catalog` | Сервис `catalog`, слоистая архитектура |
| 03 | `03-add-common-kernel` | Общая библиотека `common-kernel` |
| 04 | `04-add-basket` | Сервис `basket`, вертикальные срезы |
| 05 | `05-add-promotion` | Сервис `promotion`, компактная архитектура |
| 06 | `06-add-checkout` | Сервис `checkout`, чистая архитектура |
| 07 | `07-add-common-messaging` | Общая библиотека `common-messaging` |
| 08 | `08-add-common-metrics` | Общая библиотека `common-metrics` |

Скрипты создают начальные каркасы. Бизнес-логика, подключения к базам данных,
gRPC, Kafka, Docker Compose и мониторинг добавляются по мере разработки.
Повторное создание существующего сервиса или библиотеки отклоняется.

## Проверка каталога

В Linux и macOS:

```bash
cd src/services/catalog
```

Запустите сервис:

```bash
./gradlew :catalog-api:bootRun
```

В Windows:

```powershell
cd src/services/catalog
```

Запустите сервис:

```powershell
.\gradlew.bat :catalog-api:bootRun
```

Откройте `http://localhost:8181/hello`. Остальные порты, назначение сервисов
и будущая инфраструктура описаны в создаваемом `readme.md`.

Файлы `.ps1` сохранены в UTF-8 с BOM для чтения русского текста в Windows
PowerShell 5.1. Создаваемые файлы проекта записываются в UTF-8 без BOM;
бинарный Gradle Wrapper копируется без изменений.

Справка Microsoft: [кодировки PowerShell](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_character_encoding),
[политики выполнения](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_execution_policies).
