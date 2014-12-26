class CreateStarrings < ActiveRecord::Migration
  def change
    create_table :starrings do |t|
      t.integer :user_id, null: false
      t.integer :favorite_id, null: false
      t.string :favorite_type, null: false

      t.timestamps
    end

    remove_column :workcamps, :starred, :boolean
    remove_column :apply_forms, :starred, :boolean
  end
end
