class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.float :lon
      t.float :lat
      t.float :radius
      t.references :place_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
