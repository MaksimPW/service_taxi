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

`GET /api/v1/api_waybills/ping/ HTTP/1.1
Content-Type: application/json
{"access_token": "SECRET_TOKEN_APPLICATION"}`

### Формат ответа

`{ "version": "v1", "access": "true", "time": "2016-09-19 00:00:00 +0300" }`

## Запрос post create

### Задача

Создает путевой лист

### Пример

`POST /api/v1/api_waybills/ HTTP/1.1
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
}`

### Формат ответа

`{ "action": "create", "status": "success", "time": "2016-09-19 00:00:00 +0300" }`