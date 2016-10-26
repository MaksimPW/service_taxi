class ChangeIdTypeForWaybill < ActiveRecord::Migration
  def change
    drop_table :waybills

    create_table :waybills do |t|
      t.string :waybill_id, unique: true
      t.string :waybill_number
      t.string :car_number
      t.string :creator
      t.string :driver_alias
      t.string :fio
      t.datetime :created_waybill_at
      t.datetime :begin_road_at
      t.datetime :end_road_at

      t.timestamps null: false
    end
  end
end
