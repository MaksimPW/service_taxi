class ChangeIdCarToCarIdReferenceInStatusCars < ActiveRecord::Migration
  def change
    remove_column :status_cars, :id_car
    add_reference :status_cars, :car, index: true, foreign_key: true
  end
end
