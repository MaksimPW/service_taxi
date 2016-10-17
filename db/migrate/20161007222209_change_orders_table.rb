class ChangeOrdersTable < ActiveRecord::Migration
  def change
    remove_column :orders, :order_type_id
    add_reference :orders, :track_type, index: true, foreign_key: true
  end
end
