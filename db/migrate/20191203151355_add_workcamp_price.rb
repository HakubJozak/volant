class AddWorkcampPrice < ActiveRecord::Migration
  def change
    add_column :workcamps, :price, :decimal,
               null: true, precision: 10, scale: 2
  end
end
