# Установка JDK и Gradle для Java Marketplace

Инструкция для проектов, созданных скриптами из `scaffold/macOS`,
`scaffold/Linux` или `scaffold/Windows`.

Выполняйте команды по одной. В Windows-разделе они показаны как фрагменты
терминала: одна введённая команда и её вывод в отдельном блоке. Дождитесь
результата, затем переходите к следующему действию.
Команды одного раздела выполняйте в том же окне терминала, если явно
не указано открыть новое.

Для Windows подготовлен [отдельный пошаговый раздел: от установки JDK
до работающего каталога](#windows).

## Какие версии нужны

| Компонент | Версия | Способ установки |
|---|---|---|
| JDK | **Eclipse Temurin JDK 25 LTS**, HotSpot | Установить на компьютер |
| Gradle | **9.8.0** | Скачивается автоматически через Gradle Wrapper проекта |

В настройках сборки проекта указана Java 25. При скачивании выбирайте **JDK 25**
и актуальное обновление внутри этой версии, например `25.0.x`.
JDK включает компилятор `javac` и среду выполнения `java`.

Скачать: [Eclipse Temurin JDK 25](https://adoptium.net/temurin/releases/?version=25).
На странице выберите свою операционную систему, архитектуру и тип пакета **JDK**.

---

<a id="windows"></a>

## Windows: от установки JDK до работающего каталога

Этот раздел — полный маршрут для **Windows PowerShell** на Windows x64
с процессором Intel или AMD. Понадобятся **Eclipse Temurin JDK 25 LTS**
и папка `scaffold` со скриптами. **Gradle 9.8.0 скачает сам проект**
при первом запуске сборки.

**Каждый терминальный блок показывает одну введённую команду и её результат.**
Вводите только часть строки после `>`: приглашение `PS C:\...>` и строки
вывода набирать не нужно. Новая строка с `PS ...>` без команды означает,
что терминал готов к следующему действию.

В терминальных примерах папка проекта называется `java-shop`.
Даты, имя пользователя и время выполнения на вашем компьютере могут отличаться.

### Шаг 1. Установить JDK 25 и перезапустить терминал

1. Откройте [страницу Eclipse Temurin JDK 25](https://adoptium.net/temurin/releases/?version=25).
2. Выберите **25 LTS**, **Windows**, **x64**, **JDK**, **HotSpot** и скачайте `.msi`.
3. Запустите установщик. На шаге **Custom Setup** включите добавление Java
   в `PATH` и установку переменной `JAVA_HOME`.
4. Завершите установку.
5. **Закройте PowerShell и откройте его заново. Если используете терминал
   внутри VS Code, полностью перезапустите VS Code.**

Терминал, открытый до установки JDK, может сохранять старое окружение.
После перезапуска проверьте Java одной командой:

```text
PS C:\Users\i> java -version
openjdk version "25.0.5" 2026-10-20 LTS
OpenJDK Runtime Environment Temurin-25.0.5+8 (build 25.0.5+8-LTS)
OpenJDK 64-Bit Server VM Temurin-25.0.5+8 (build 25.0.5+8-LTS, mixed mode, sharing)
```

Затем отдельно проверьте компилятор:

```text
PS C:\Users\i> javac -version
javac 25.0.5
```

Номер обновления `25.0.x` может отличаться. Обе команды должны показывать
версию **25**. Если они работают, переходите к созданию проекта.
[Инструкция Adoptium для Windows](https://adoptium.net/installation/windows/).

### Шаг 2. Подготовить папки и перейти в java-shop

Создайте на рабочем столе папку `project` и распакуйте в неё `scaffold`.
Затем рядом со `scaffold` будет создана папка `java-shop`:

```text
project/
  scaffold/
    Windows/
      01-init-repo.ps1
      02-add-catalog.ps1
      ...
  java-shop/
```

В примерах имя пользователя — `i`. Подставьте свой путь к папке `project`.
Сначала перейдите в неё:

```text
PS C:\Users\i> cd "$env:USERPROFILE\Desktop\project"
PS C:\Users\i\Desktop\project>
```

В примерах переход в папку выполняется командой `cd`. В PowerShell это
псевдоним полной команды `Set-Location`. Если `cd` не распознаётся или был
переопределён, используйте `Set-Location` с тем же путём. Например, вместо
`cd .\java-shop\` введите `Set-Location .\java-shop\`.

Если сообщение говорит, что папка не найдена, проверьте путь и текущую папку:
замена имени команды не исправляет неверный путь.
[Справка Microsoft о Set-Location и его псевдонимах](https://learn.microsoft.com/powershell/module/microsoft.powershell.management/set-location?view=powershell-5.1).

Создайте пустую папку `java-shop`. Команда выводит сведения о созданном каталоге:

```text
PS C:\Users\i\Desktop\project> mkdir java-shop


    Каталог: C:\Users\i\Desktop\project


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        02.11.2026      2:52                java-shop
```

Теперь выполните только команду перехода в `java-shop`. Изменение пути видно
в следующем приглашении PowerShell:

```text
PS C:\Users\i\Desktop\project> cd .\java-shop\
PS C:\Users\i\Desktop\project\java-shop>
```

**Если `java-shop` уже создана, пропустите `mkdir java-shop` и просто перейдите в неё.**
Не создавайте внутри неё ещё одну `java-shop`: из `java-shop\java-shop` относительный путь
к скриптам будет другим.

### Шаг 3. Создать основу проекта

Находясь в `java-shop`, запустите первый скрипт. На вопрос о Java-пакете нажмите
Enter для `ru.ksergey.marketplace` или введите свой, например
`com.example.marketplace`. Пример запуска с выбором значения по умолчанию:

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

Пакет сохранён в `java-shop\scaffold.conf`; следующие скрипты прочитают его
автоматически. Список после слов «Добавление сервисов и библиотек» —
подсказки для дальнейших шагов. Первый скрипт только печатает их.
Каждый следующий скрипт запускайте отдельно, когда дойдёте до его шага.

В этой инструкции используется запуск через
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File`. Он позволяет
запустить выбранный `.ps1` в отдельном процессе без изменения постоянной
политики системы. Так можно продолжать и при сообщении Windows
«выполнение сценариев отключено».
[Описание политик выполнения Microsoft](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_execution_policies).

### Шаг 4. Добавить сервис catalog

Оставайтесь в `java-shop` и запустите второй скрипт одной командой:

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

В `java-shop\src\services\catalog` созданы Gradle Wrapper и четыре модуля:
`catalog-domain`, `catalog-application`, `catalog-infrastructure`, `catalog-api`.
При своём базовом пакете путь к Java-файлам будет соответствовать ему.

В конце вывода показаны подсказки для проверки. Выполняйте их отдельно
по следующим шагам. Напечатанный `Set-Location` можно заменить на `cd`.

### Шаг 5. Собрать проект

Сначала перейдите из `java-shop` в каталог сервиса:

```text
PS C:\Users\i\Desktop\project\java-shop> cd .\src\services\catalog\
PS C:\Users\i\Desktop\project\java-shop\src\services\catalog>
```

Теперь выполните одну команду сборки — `.\gradlew.bat build`.
При первом запуске Wrapper скачает Gradle 9.8.0, затем плагины и зависимости.
Фрагмент первого запуска:

```text
PS C:\Users\i\Desktop\project\java-shop\src\services\catalog> .\gradlew.bat build
Fetching distribution.
Downloading https://services.gradle.org/distributions/gradle-9.8.0-bin.zip
..............10%..............20%...............30%..............40%...............50%..............60%...............70%..............80%...............90%..............100%

Welcome to Gradle 9.8.0!

Here are the highlights of this release:
 - Java 27 support
 - Maven mirror settings reuse
 - Linked problem locations in build output

For more details see https://docs.gradle.org/9.8.0/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)
[############...] 82% EXECUTING [1m 14s]
> IDLE
> IDLE
> IDLE
> IDLE
> IDLE
> IDLE
> IDLE
> IDLE
> IDLE
> IDLE
> IDLE
> :catalog-api:bootJar
> IDLE
> IDLE
> IDLE
```

Это промежуточный вывод: **82% EXECUTING ещё не означает
завершение сборки**. Строки `IDLE` могут появляться во время работы Gradle.
Дождитесь **`BUILD SUCCESSFUL`**. Время зависит от интернета и компьютера.
Упоминание Java 27 в списке нововведений Gradle не меняет настройку проекта:
для этого проекта используется JDK 25.

Повторная сборка выполняется той же отдельной командой:

```text
PS C:\Users\i\Desktop\project\java-shop\src\services\catalog> .\gradlew.bat build

BUILD SUCCESSFUL in 1s
11 actionable tasks: 11 up-to-date
Consider enabling configuration cache to speed up this build: https://docs.gradle.org/9.8.0/userguide/configuration_cache_enabling.html
PS C:\Users\i\Desktop\project\java-shop\src\services\catalog>
```

`BUILD SUCCESSFUL` означает успешную сборку. `up-to-date` — результаты
задач актуальны и их не потребовалось создавать заново. Число задач и время
могут отличаться. Собранный JAR находится в `catalog-api\build\libs`.

Запускайте файл **`.\gradlew.bat`**. Папка `.\gradle\` содержит настройки
Wrapper. Системная установка Gradle для проекта не требуется.
[Описание Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html).

### Шаг 6. Запустить каталог

В той же папке `catalog` выполните одну команду:

```text
PS C:\Users\i\Desktop\project\java-shop\src\services\catalog> .\gradlew.bat :catalog-api:bootRun
```

Дождитесь в логах сообщения, содержащего **`Started CatalogApplication`**.
Сервис использует порт **8181**.

**Оставьте это окно открытым:** пока приложение работает, терминал занят
сервером. Для `bootRun` не нужно ждать завершения с `BUILD SUCCESSFUL` —
приложение продолжает работать. HTTP-запрос выполняется во втором окне.

### Шаг 7. Проверить ответ во втором окне PowerShell

Откройте второе окно PowerShell. Текущая папка для HTTP-запроса не важна.
Выполните одну команду с `-UseBasicParsing`. Пример ожидаемого ответа:

```text
PS C:\Users\i> Invoke-WebRequest -Uri 'http://localhost:8181/hello' -UseBasicParsing | Select-Object StatusCode, Content
StatusCode Content
---------- -------
       200 Catalog is up
```

Ответ **200** и текст **`Catalog is up`** подтверждают работу сервиса.
Адрес также можно открыть в браузере: `http://localhost:8181/hello`.

#### Почему curl может запросить подтверждение

При вызове `curl` Windows PowerShell может запросить подтверждение:

```text
PS C:\Users\i> curl http://localhost:8181/hello

Предупреждение безопасности: риск выполнения сценария
Invoke-WebRequest анализирует содержимое веб-страницы. При анализе страницы может выполняться код сценария на
веб-странице.
      РЕКОМЕНДУЕМОЕ ДЕЙСТВИЕ:
      Используйте параметр -UseBasicParsing, чтобы предотвратить выполнение кода сценария.

      Продолжить?

[Y] Да - Y  [A] Да для всех - A  [N] Нет - N  [L] Нет для всех - L  [S] Приостановить - S  [?] Справка
(значением по умолчанию является "N"):Y


StatusCode        : 200
StatusDescription :
Content           : Catalog is up
RawContent        : HTTP/1.1 200
                    Keep-Alive: timeout=60
                    Connection: keep-alive
                    Content-Length: 13
                    Content-Type: text/plain;charset=UTF-8
                    Date: Mon, 02 Nov 2026 00:13:25 GMT

                    Catalog is up
Forms             : {}
Headers           : {[Keep-Alive, timeout=60], [Connection, keep-alive], [Content-Length, 13], [Content-Type, text/plai
                    n;charset=UTF-8]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : System.__ComObject
RawContentLength  : 13
```

В Windows PowerShell 5.1 `curl` — псевдоним `Invoke-WebRequest`.
Предупреждение относится к обработке ответа в PowerShell. Для проверки
используйте приведённую выше команду с `-UseBasicParsing`: она показывает
результат без этого запроса подтверждения.
[Пояснение Microsoft о Invoke-WebRequest](https://support.microsoft.com/en-us/servicing/os/windows/2025/12/powershell-5-1-invoke-webrequest-preventing-script-execution-from-web-content).

### Шаг 8. Остановить сервис и продолжить разработку

Вернитесь в первое окно с `bootRun` и нажмите **Ctrl+C**.
Если Windows попросит подтвердить завершение пакетного файла, подтвердите его.

Для дальнейших скриптов вернитесь из `catalog` в корень `java-shop` одной командой:

```text
PS C:\Users\i\Desktop\project\java-shop\src\services\catalog> cd ..\..\..
PS C:\Users\i\Desktop\project\java-shop>
```

Когда по ходу разработки понадобится `common-kernel`, запустите третий
скрипт отдельно из `java-shop`:

```text
PS C:\Users\i\Desktop\project\java-shop> powershell.exe -NoProfile -ExecutionPolicy Bypass -File '..\scaffold\Windows\03-add-common-kernel.ps1'
```

Он создаёт библиотеку в `src\shared\common-kernel`. Все скрипты `01`–`08`
запускаются из `java-shop`; Gradle запускается из каталога соответствующего сервиса
или библиотеки. Полный порядок шагов приведён
в [инструкции по scaffold](readme.md#порядок-шагов).

### Если что-то пошло не так

| Сообщение или ситуация | Что проверить |
|---|---|
| `java` не найдена, `JAVA_HOME is not set` | После установки JDK перезапустите PowerShell или VS Code. В новом окне выполните `java -version` и `javac -version` |
| `JAVA_HOME is set to an invalid directory` | Исправьте `JAVA_HOME`: нужен корень установленного JDK 25, содержащий папку `bin` |
| `cd` не распознаётся как команда | Используйте `Set-Location` с тем же путём |
| `.ps1` не найден, `CommandNotFoundException` | Проверьте текущую папку: `java-shop` должна находиться рядом со `scaffold`. Вложенная `java-shop\java-shop` меняет относительный путь |
| Выполнение сценариев отключено | Запустите шаг через `powershell.exe -NoProfile -ExecutionPolicy Bypass -File`, как в примерах |
| `.\gradlew.bat` не найден | Перейдите в `java-shop\src\services\catalog`. Wrapper появляется после второго скрипта |
| HTTP-запрос не может подключиться | Проверьте, что первое окно с `bootRun` открыто и в логах есть `Started CatalogApplication` |

Если после перезапуска `java` и `javac` работают, а `JAVA_HOME` пустой,
Wrapper может использовать Java из `PATH`. Пустая переменная сама по себе
не означает ошибку: сначала попробуйте `.\gradlew.bat --version`.

Если требуется явно выбрать этот JDK, выполните в работающем окне PowerShell:

```text
PS C:\Users\i> $jdkHomeLine = java -XshowSettings:properties -version 2>&1 | Select-String '^\s*java\.home\s*=' | Select-Object -First 1
```

Убедитесь, что Java сообщила путь:

```text
PS C:\Users\i> if ($null -eq $jdkHomeLine) { throw 'Java не сообщила путь к JDK' }
```

Извлеките путь к установленному JDK:

```text
PS C:\Users\i> $jdkPath = ($jdkHomeLine.Line -split '=', 2)[1].Trim()
```

Проверьте наличие компилятора в этой папке:

```text
PS C:\Users\i> if (-not (Test-Path -LiteralPath "$jdkPath\bin\javac.exe" -PathType Leaf)) { throw "Компилятор не найден в $jdkPath" }
```

Задайте `JAVA_HOME` в текущем окне:

```text
PS C:\Users\i> $env:JAVA_HOME = $jdkPath
```

Сохраните значение для будущих сеансов пользователя:

```text
PS C:\Users\i> [Environment]::SetEnvironmentVariable('JAVA_HOME', $jdkPath, 'User')
```

Запустите компилятор из выбранного JDK. Оператор `&` выполняет файл по пути в кавычках:

```text
PS C:\Users\i> & "$env:JAVA_HOME\bin\javac.exe" -version
```

Так `JAVA_HOME` сохраняется для текущего окна и будущих сеансов пользователя.
Переменная должна указывать на корень JDK, без окончания `\bin` и без кавычек
в самом значении. Текущий путь можно посмотреть командой `$env:JAVA_HOME`.
[Сохранение переменных окружения в PowerShell](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_environment_variables).
---

## macOS: установка JDK

На странице Temurin выберите Java **25 LTS**, **macOS**, **JDK**, **HotSpot**
и скачайте установщик `.pkg`. Архитектура:

- **aarch64 / ARM64** — Mac с Apple Silicon: M1, M2, M3 и следующие поколения;
- **x64** — Mac с процессором Intel.

Откройте `.pkg` и завершите установку. Затем в терминале выполните:

```bash
/usr/libexec/java_home -V
```

Выберите JDK 25:

```bash
export JAVA_HOME="$(/usr/libexec/java_home -v 25)"
```

Добавьте каталог исполняемых файлов выбранного JDK в начало `PATH`:

```bash
export PATH="$JAVA_HOME/bin:$PATH"
```

Проверьте версию Java:

```bash
java -version
```

Проверьте компилятор Java:

```bash
javac -version
```

Первая команда показывает установленные JDK. Обе команды версии должны
показывать **25**.

Чтобы выбор JDK сохранялся после открытия нового терминала, добавьте в конец
`~/.zshrc` эти две строки:

```bash
export JAVA_HOME="$(/usr/libexec/java_home -v 25)"
```

Добавьте каталог исполняемых файлов выбранного JDK в начало `PATH`:

```bash
export PATH="$JAVA_HOME/bin:$PATH"
```

Примените настройку:

```bash
source ~/.zshrc
```

Это настройка для стандартной оболочки macOS — Zsh. Если используете Bash,
добавьте строки в `~/.bash_profile`. После изменения переменных также
перезапустите редактор, из которого запускаете сборку.

Если Homebrew уже установлен, вместо скачивания `.pkg` можно выполнить:

```bash
brew install --cask temurin@25
```

Затем настройте `JAVA_HOME` и проверьте версии, как показано выше.

Источники: [установщик Temurin для macOS](https://adoptium.net/installation/macOS/),
[Temurin 25 в Homebrew](https://formulae.brew.sh/cask/temurin@25).

## Linux: установка JDK

Ниже команды для **Ubuntu и Debian**. Выполняйте их в терминале Bash.
Для других дистрибутивов воспользуйтесь
[инструкцией Adoptium для Linux](https://adoptium.net/installation/linux/).

Установите инструменты для подключения репозитория:

```bash
sudo apt update
```

Установите необходимые инструменты:

```bash
sudo apt install -y wget gpg ca-certificates apt-transport-https
```

Создайте каталог для ключей репозиториев:

```bash
sudo install -d -m 0755 /etc/apt/keyrings
```

Добавьте ключ и репозиторий Adoptium:

```bash
wget -qO- https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/keyrings/adoptium.gpg > /dev/null
```

Определите кодовое имя дистрибутива:

```bash
distro_codename="$(awk -F= '/^VERSION_CODENAME=/{print $2}' /etc/os-release)"
```

Подключите репозиторий Adoptium:

```bash
printf 'deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb %s main\n' "$distro_codename" | sudo tee /etc/apt/sources.list.d/adoptium.list
```

Установите JDK 25 и проверьте его:

```bash
sudo apt update
```

Установите JDK 25:

```bash
sudo apt install -y temurin-25-jdk
```

Проверьте версию Java:

```bash
java -version
```

Проверьте компилятор Java:

```bash
javac -version
```

Обе версии должны начинаться с **25**. Если уже установлена другая Java,
выберите JDK 25 для обеих команд:

```bash
sudo update-alternatives --config java
```

Выберите компилятор из JDK 25:

```bash
sudo update-alternatives --config javac
```

Задайте `JAVA_HOME` по расположению выбранного компилятора:

```bash
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")"
```

Добавьте каталог исполняемых файлов выбранного JDK в начало `PATH`:

```bash
export PATH="$JAVA_HOME/bin:$PATH"
```

Посмотрите выбранный путь:

```bash
printf '%s\n' "$JAVA_HOME"
```

Проверьте версию Java:

```bash
java -version
```

Проверьте компилятор Java:

```bash
javac -version
```

Для сохранения настройки добавьте обе строки `export` в конец `~/.bashrc`
и выполните `source ~/.bashrc`. Если используете другую оболочку, настройте её
файл запуска. Перезапустите редактор, чтобы он получил новое окружение.

Эти команды подключения репозитория рассчитаны на Ubuntu и Debian с полем
`VERSION_CODENAME` в `/etc/os-release`. Для Linux Mint и других производных
систем порядок настройки уточняйте в инструкции Adoptium.

## Gradle: установка через Wrapper проекта

В каждом создаваемом сервисе и общей библиотеке уже есть:

```text
gradlew
gradlew.bat
gradle/wrapper/gradle-wrapper.jar
gradle/wrapper/gradle-wrapper.properties
```

В `gradle-wrapper.properties` закреплён **Gradle 9.8.0**. При первом запуске
Wrapper скачает эту версию и сохранит её в пользовательском кэше.
Для скачивания нужен доступ в интернет. Отдельно устанавливать Gradle
и задавать `GRADLE_HOME` для этого проекта не требуется.

После выполнения скриптов `01-init-repo` и `02-add-catalog` перейдите
из корня созданного проекта в каталог сервиса.

В Windows, PowerShell:

```powershell
cd src/services/catalog
```

Проверьте версию Gradle через Wrapper:

```powershell
.\gradlew.bat --version
```

Запустите каталог:

```powershell
.\gradlew.bat :catalog-api:bootRun
```

В macOS и Linux:

```bash
cd src/services/catalog
```

Проверьте версию Gradle через Wrapper:

```bash
./gradlew --version
```

Запустите каталог:

```bash
./gradlew :catalog-api:bootRun
```

Команда `--version` должна показать **Gradle 9.8.0**, а в информации о JVM —
выбранный JDK 25. После запуска каталога откройте
`http://localhost:8181/hello`. Для остановки нажмите `Ctrl+C`.

У сервисов и библиотек отдельные Gradle-проекты. Выполняйте команды Wrapper
из нужной папки, например `src/services/catalog` или `src/shared/common-kernel`.
В корне создаваемого проекта `gradlew` нет.

Если в macOS или Linux команда `./gradlew` сообщает `Permission denied`,
из каталога соответствующего сервиса выполните:

```bash
chmod +x gradlew
```

Проверьте версию Gradle через Wrapper:

```bash
./gradlew --version
```

Если `java -version` показывает 25, а Wrapper использует другую JVM,
проверьте `JAVA_HOME`, настройку Gradle JVM в редакторе и наличие параметра
`org.gradle.java.home` в пользовательском или проектном `gradle.properties`.
После исправления остановите старые демоны командой `./gradlew --stop`
или `.\gradlew.bat --stop` и повторите `--version`.

Источник: [официальная документация Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html).
