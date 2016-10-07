class RenameTableOrderTypesToTrackTypes < ActiveRecord::Migration
  def change
    rename_table :order_types, :track_types
  end
end