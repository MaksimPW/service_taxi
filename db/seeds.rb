# Пометка: При deployment приложения заменить значения user на правильные
User.create(email: 'admin@admin.ru', password: 'admin@admin.ru', password_confirmation: 'admin@admin.ru')

# Create default settings app
Setting.create(
    max_diff_between_actual_track: 20,    # percents
    max_rest_time_after_order: 900,       # seconds
    max_park_distance_after_order: 0.5,   # km
    max_rest_time: 3600,                  # seconds
    max_park_time: 25200,                 # seconds
    max_diff_geo: 0.020,                  # km
    max_stay_speed: 10                    # km/h
)

PlaceType.create(id: 1, name: 'Парк')
PlaceType.create(id: 2, name: 'Метро')
PlaceType.create(id: 3, name: 'АЗС')
PlaceType.create(id: 4, name: 'Место ожидания первого заказа')

TrackType.create(id: 1, name: 'Поездка из парка до места ожидания первого заказа')
TrackType.create(id: 2, name: 'Поездка от ожидания заказа к месту подачи')
TrackType.create(id: 3, name: 'Поездка по заказу')
TrackType.create(id: 4, name: 'Превышен лимит по дистанции')
TrackType.create(id: 5, name: 'Данных мало или они отсутствуют')
TrackType.create(id: 6, name: 'Поездка по заказу не туда')
TrackType.create(id: 7, name: 'Поездка из парка до места ожидания первого заказа, а дальше от места ожидания первого заказа к месту подачи')
TrackType.create(id: 8, name: 'Ожидание между заказами')
TrackType.create(id: 9, name: 'Поездка на отдых')
