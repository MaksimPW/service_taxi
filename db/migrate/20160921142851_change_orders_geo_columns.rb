class ChangeOrdersGeoColumns < ActiveRecord::Migration
  def change
    rename_column :orders, :begin_address_name, :begin_address
    rename_column :orders, :end_address_name, :end_address

    add_column :orders, :begin_lat, :float
    add_column :orders, :begin_lon, :float
    add_column :orders, :end_lat, :float
    add_column :orders, :end_lon, :float

    remove_column :orders, :begin_geo, :float
    remove_column :orders, :end_geo, :float
  end
end