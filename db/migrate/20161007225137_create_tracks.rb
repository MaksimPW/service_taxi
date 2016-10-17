class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.text :note
      t.datetime :begin_time
      t.datetime :end_time
      t.references :order, index: true, foreign_key: true
      t.references :track_type, index: true, foreign_key: true
      t.references :car, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
