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
)

PlaceType.create(id: 1, name: 'Парк')
PlaceType.create(id: 2, name: 'Метро')
PlaceType.create(id: 3, name: 'АЗС')
PlaceType.create(id: 4, name: 'Место ожидания первого заказа')

OrderType.create(id: 1, name: 'Поездка из парка до места ожидания первого заказа')
OrderType.create(id: 2, name: 'Поездка от ожидания заказа к месту подачи')
OrderType.create(id: 3, name: 'Поездка по заказу')
OrderType.create(id: 4, name: 'Превышен лимит по дистанции')