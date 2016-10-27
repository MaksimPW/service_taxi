class AddZipForCarsDriversOrders < ActiveRecord::Migration
  def change
    add_column :cars, :zip, :integer, unique: true
    add_column :drivers, :zip, :integer, unique: true
    add_column :orders, :zip, :string, unique: true
  end
end
