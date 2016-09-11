class CreateStatusCars < ActiveRecord::Migration
  def change
    create_table :status_cars do |t|
      t.float :geo_lat
      t.float :geo_lon
      t.string :license_number
      t.float :speed
      t.datetime :fixed_time
      t.string :name
      t.string :model
      t.integer :id_car
      t.integer :ext_id
      t.integer :course

      t.timestamps null: false
    end
  end
end
