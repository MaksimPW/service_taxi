# Интеграция с 1С
1. Зарегистрироваться на сайте
2. Авторизироваться на сайте
3. Зайти на http://localhost:3000/oauth/applications
4. Нажать "New Application"
5. Указать Name и Redirect URI.
 > В целях тестирования указать Redirect URI: `urn:ietf:wg:oauth:2.0:oob`

6. Создать Application

## Параметры запроса

Параметры запроса должны быть переданы в теле запроса HTTP POST, в формате json, в
кодировке UTF-8. Для авторизации понадобиться добавить в тело запроса "access_token" с SECRET вашего приложения, которое было создано в /oauth/applications

## Запрос get ping

### Задача

Проверяет доступ к api приложения

### Пример
```
GET /api/v1/api_waybills/ping/ HTTP/1.1
Content-Type: application/json
{"access_token": "SECRET_TOKEN_APPLICATION"}
```

### Формат ответа

`{ "version": "v1", "access": "true", "time": "2016-09-19 00:00:00 +0300" }`

## Запрос post create

### Задача

Создает путевой лист

### Пример
```
POST /api/v1/api_waybills/ HTTP/1.1
Content-Type: application/json
{"access_token": "SECRET_TOKEN_APPLICATION",
"waybill_number": "123456",
"car_number": "a123bc",
"creator": "",
"driver_alias": "123abc",
"fio": "Ivanov Ivan Ivanich",
"created_waybill_at": "2016-09-16 07:27:44",
"begin_road_at": "2016-09-16 10:00:00",
"end_road_at": "2016-09-16 11:00:00"
}
```

### Формат ответа

`{ "action": "create", "status": "success", "time": "2016-09-19 00:00:00 +0300" }`

# Интеграция с георитм

Для интеграции используются внутренние HTTP запросы, которые потом будут испольняться с помощью автоматически запускамых скриптов

Описание | Запрос
------------------------------------------- | -------------
Проверка подключения к API георитма         | `get :ping`
Получение ключа Basic Auth для работы с API | `get :init`
Получение данных о текущем состоянии машин  | `post :execute`


## Настройка

Создать или изменить файл config/secrets.yml
Добавить в нужную среду исполнения ключи для подключения к API георитма (значения не нужно заключать в кавычки).

Пример:

```
## config/secrets.yml
development:
  integration_georitm_login: test@example.com
  integration_georitm_password: 12345678
  integration_georitm_host: 127.0.0.1
  integration_georitm_port: 81
```

# Интеграция с радиотакси

Для интеграции используются внутренние HTTP запросы, которые потом будут испольняться с помощью автоматически запускамых скриптов

Описание | Запрос
------------------------------------------ | -------------
Получение данных о машинах                 | `post :cars`
Получение данных о водителях               | `post :drivers`
Получение данных о заказах за `take_date`  | `post :orders, take_date: '2016-09-13'`


## Настройка

Создать или изменить файл config/database.yml
Добавить в нужную среду исполнения ключи для подключения к базе данных радиотакси (значения не нужно заключать в кавычки).

Пример:

```
## config/database.yml
  development_integration_radiotaxi:
    <<: *default
    adapter: fb
    database: /var/lib/firebird/2.5/data/test_rt.fdb
    username: sysdba
    password: masterkey
    host: 127.0.0.1
    encoding: cp1251
```

# Тестирование

Запуск тестов: `bundle exec rspec`

Для корректной работы тестов понадобиться заполнить данные о подключении к георитму и радиотакси.

Просьба не указывать данные production серверов, а создать свои тестовые данные(база данных firebird для радиотакси, отдельный сервер с георитмом).

При тестировании базы данных firebird для радиотакси заполнить коллекции базы таким образом, как это было сделано на production, а так же создать ровно такое количество данных в базе, сколько было указано в тестах по пути spec/controllers/integration/radiotaxi_controllers_spec.rb