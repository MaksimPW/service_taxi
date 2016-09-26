class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.float :max_diff_between_actual_track
      t.integer :max_rest_time_after_order
      t.integer :max_park_distance_after_order
      t.integer :max_rest_time
      t.integer :max_park_time
      t.float :max_diff_geo

      t.timestamps null: false
    end
  end
end
