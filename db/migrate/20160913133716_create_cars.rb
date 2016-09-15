class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :mark
      t.string :license_number
      t.references :driver, index: true, foreign_key: true
      t.text :description

      t.timestamps null: false
    end
  end
end
