class AddTypeToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :order_type, index: true, foreign_key: true
  end
end
