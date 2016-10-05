class ChangeTableSettings < ActiveRecord::Migration
  def change
    change_column :settings, :max_park_distance_after_order, :float
  end
end
