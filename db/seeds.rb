# Пометка: При deployment приложения заменить значения user на правильные
User.create(email: 'admin@admin.ru', password: 'admin@admin.ru', password_confirmation: 'admin@admin.ru')

# Create default settings app
Setting.create(
    max_diff_between_actual_track: 10,
    max_rest_time_after_order: 900,
    max_park_distance_after_order: 500,
    max_rest_time: 3600,
    max_park_time: 25200,
    max_diff_geo: 10,
)

PlaceType.create(id: 1, name: 'Парк')
PlaceType.create(id: 2, name: 'Метро')
PlaceType.create(id: 3, name: 'АЗС')
PlaceType.create(id: 4, name: 'Место ожидания первого заказа')
