class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :fio
      t.text :description

      t.timestamps null: false
    end
  end
end
