class AddAliasToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :alias, :string
  end
end
