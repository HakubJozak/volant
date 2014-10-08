class AddStarredFlag < ActiveRecord::Migration
  def change
    add_column :workcamps, :starred, :boolean, default: false, null: false
    add_column :apply_forms, :starred, :boolean, default: false, null: false
  end
end
