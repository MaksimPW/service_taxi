class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :car, index: true, foreign_key: true
      t.references :driver, index: true, foreign_key: true
      t.boolean :status_buy
      t.string :operator
      t.datetime :take_time
      t.datetime :begin_time
      t.datetime :end_time
      t.string :begin_address_name
      t.string :end_address_name
      t.float :begin_geo
      t.float :end_geo
      t.float :cost
      t.float :distance
      t.text :description

      t.timestamps null: false
    end
  end
end
