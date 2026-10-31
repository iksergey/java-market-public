# __project__

Академический проект бэкенда интернет-магазина на Java. Система состоит из четырёх
микросервисов: каталога товаров, корзины, промоакций и заказов. Каждый сервис
развивается как отдельный Gradle-проект со своей базой данных.

В проекте последовательно добавляются REST API, работа с данными, валидация,
обработка ошибок, синхронное взаимодействие по gRPC и обмен событиями через Kafka.
Завершающая часть — запуск в Docker, сбор метрик, дашборды и нагрузочные проверки.

Этот README описывает состав и соглашения будущей системы. Скрипты scaffold
создают начальные каркасы сервисов и библиотек. Бизнес-логика, подключения к БД,
gRPC, Kafka, Docker Compose и мониторинг добавляются по мере разработки.

## Сервисы

| Сервис | Архитектура | Хранение | Назначение |
|---|---|---|---|
| `catalog` | Слоистая | MongoDB | Товары, бренды и категории; поиск, фильтрация, сортировка и пагинация |
| `basket` | Вертикальные срезы | PostgreSQL, JSONB, Redis | Сохранение и получение корзины, кэширование, применение скидок и оформление заказа |
| `promotion` | Компактная | MySQL, JdbcClient | Хранение промоакций и расчёт скидок по gRPC |
| `checkout` | Чистая | PostgreSQL, JPA, Flyway | Создание, хранение и получение заказов; обработка событий из Kafka |

`catalog` и `checkout` разделены на модули `domain`, `application`,
`infrastructure` и `api`. В `basket` код сгруппирован по операциям: сохранение,
получение, удаление корзины и оформление заказа. В `promotion` используется один
модуль с пакетами моделей, сценариев, доступа к данным и перехватчиков.

Клиенты обращаются к HTTP API каталога, корзины и заказов. Корзина запрашивает
скидку у `promotion` по gRPC. При оформлении корзины `basket` публикует событие
в Kafka, а `checkout` получает его и создаёт заказ. Контракты событий описываются
в Avro; схемы хранятся в Schema Registry.

## Общие библиотеки

| Библиотека | Назначение |
|---|---|
| `common-kernel` | Контракты CQRS, диспетчер команд и запросов, валидация и общая обработка ошибок |
| `common-messaging` | Общие контракты интеграционных событий, Avro-схемы и заголовки сообщений |
| `common-metrics` | Общие настройки Actuator и метрик Prometheus |

Библиотеки подключаются через `includeBuild` в `settings.gradle.kts` сервиса
и зависимости в его `build.gradle.kts`.

## Структура репозитория

```
scaffold.conf
src/
  services/
    catalog/
    basket/
    promotion/
    checkout/
  shared/
    common-kernel/
    common-messaging/
    common-metrics/
docker/
docker-compose-dev.yaml
docker-compose-prod.yaml
prometheus/
grafana/
k6/
```

`src/services` и `src/shared` создаются при инициализации. Сервисы и библиотеки
добавляются отдельными скриптами. Каталоги `docker`, `prometheus`, `grafana`, `k6`
и файлы Compose появляются на соответствующих этапах разработки.

Базовый пакет — `__basepkg__`. Первый скрипт `01-init-repo.ps1` запрашивает его
при создании проекта. Enter оставляет значение по умолчанию из `scaffold.conf`
рядом со скриптами. Выбранное значение сохраняется в отдельный `scaffold.conf`
в корне проекта как `BASE_PACKAGE`.

Все последующие скрипты читают настройку из корня этого проекта и используют её
для Gradle-группы, Java-пакетов, структуры папок и зависимостей на общие библиотеки.
Конфигурацию следует сохранять вместе с проектом и не менять между шагами:
изменение настройки влияет только на вновь создаваемые файлы.

Код и имена файлов — на английском,
документация — на русском. У каждого сервиса и библиотеки свой Gradle Wrapper;
команды сборки выполняются из каталога соответствующего проекта.

## Стек

Java 25, Spring Boot 4.1.1, Gradle 9.8.0 и Kotlin DSL. Для HTTP API используются
Spring MVC и OpenAPI, для доступа к данным — Spring Data MongoDB, Spring Data JPA
и JdbcClient. Дополнительно применяются Redis, Flyway, MapStruct, Lombok,
Bean Validation, gRPC/Protobuf, Kafka и Avro.

Инфраструктура включает MongoDB, PostgreSQL, MySQL, Redis, Kafka, Schema Registry
и Kafka UI. Метрики собирает Prometheus, дашборды отображает Grafana. Для
нагрузочных проверок используется k6, для управления контейнерами — Portainer.

## Контейнеры и порты

В режиме `dev` приложения запускаются на Windows, инфраструктура — в Docker.
В режиме `prod` и приложения, и инфраструктура работают в контейнерах. Имена
Compose-проектов: `java-market-dev` и `java-market-prod`.

### Приложения

| Сервис | Протокол | Порт на Windows в dev | Контейнер prod | Порт хоста → порт контейнера в prod |
|---|---|---|---|---|
| `catalog` | HTTP | `8181` | `prod_catalog_api` | `28181 → 8181` |
| `basket` | HTTP | `8182` | `prod_basket_api` | `28182 → 8182` |
| `promotion` | gRPC | `8183` | `prod_promotion_grpc` | `28183 → 8183` |
| `promotion` | HTTP / Actuator | `8193` | `prod_promotion_grpc` | `28193 → 8193` |
| `checkout` | HTTP | `8184` | `prod_checkout_api` | `28184 → 8184` |

Порты gRPC и Actuator у `promotion` настраиваются при добавлении этих компонентов.
Начальный каркас этого сервиса содержит только имя приложения.

### Инфраструктура

| Компонент | Контейнер dev | Контейнер prod | Порт хоста dev / prod | Порт внутри Docker |
|---|---|---|---|---|
| MongoDB каталога | `catalog_db` | `prod_catalog_db` | `15001 / 25001` | `27017` |
| PostgreSQL корзины | `basket_db` | `prod_basket_db` | `15002 / 25002` | `5432` |
| PostgreSQL заказов | `checkout_db` | `prod_checkout_db` | `15003 / 25003` | `5432` |
| MySQL промоакций | `promotion_db` | `prod_promotion_db` | `15004 / 25004` | `3306` |
| Redis корзины | `basket_redis` | `prod_basket_redis` | `15005 / 25005` | `6379` |
| Kafka | `kafka` | `prod_kafka` | `15010 / 25010` | `9092` с хоста, `29092` между контейнерами |
| Schema Registry | `schema_registry` | `prod_schema_registry` | `15011 / 25011` | `8081` |
| Kafka UI | `kafka_ui` | `prod_kafka_ui` | `15012 / 25012` | `8080` |
| Prometheus | `prometheus` | `prod_prometheus` | `15030 / 25030` | `9090` |
| Grafana | `grafana` | `prod_grafana` | `15031 / 25031` | `3000` |
| Portainer | — | `prod_portainer` | `— / 25040` | `9443`, HTTPS |

k6 запускается с профилем Compose `load` и не публикует порты. Контейнер в dev —
`k6`, в prod — `prod_k6_catalog` и `prod_k6_cart`.

Приложения на Windows подключаются к инфраструктуре через `localhost` и порты dev.
Внутри Docker подключения используют имена сервисов Compose и внутренние порты:
например, `catalog_db:27017`, `kafka:29092` и `schema-registry:8081`.

## Запуск

Для работы нужны JDK 25 и Docker с Docker Compose. Gradle запускается через
включённый в каждый проект Wrapper.

Выполняйте команды по одной, дожидаясь результата каждого шага.
После создания каркаса каталога перейдите в его каталог:

```powershell
cd src/services/catalog
```

Запустите сервис:

```powershell
.\gradlew.bat :catalog-api:bootRun
```

Начальная проверка каталога — `GET http://localhost:8181/hello`. После добавления
бизнес-логики этот контроллер заменяется API товаров, брендов и категорий.

Следующие команды используются после добавления файлов Compose, Dockerfile
и соответствующих конфигураций.

Инфраструктура dev из корня репозитория:

```powershell
docker compose -f docker-compose-dev.yaml up -d
```

Приложения в dev запускаются из IDE или через Gradle в отдельных терминалах:

| Каталог | Команда |
|---|---|
| `src/services/catalog` | `.\gradlew.bat :catalog-api:bootRun` |
| `src/services/basket` | `.\gradlew.bat bootRun` |
| `src/services/promotion` | `.\gradlew.bat bootRun` |
| `src/services/checkout` | `.\gradlew.bat :checkout-api:bootRun` |

Весь prod-контур из корня репозитория:

```powershell
docker compose -f docker-compose-prod.yaml up -d --build
```

Посмотреть статус dev-контура:

```powershell
docker compose -f docker-compose-dev.yaml ps
```

Посмотреть логи; для выхода из просмотра нажмите `Ctrl+C`:

```powershell
docker compose -f docker-compose-dev.yaml logs -f
```

Остановить dev-контур:

```powershell
docker compose -f docker-compose-dev.yaml down
```

Для prod в этих командах используется `docker-compose-prod.yaml`. Обычная
остановка сохраняет данные в томах Docker.
