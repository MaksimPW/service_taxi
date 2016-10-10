class AddMaxStaySpeedToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :max_stay_speed, :float
  end
end
