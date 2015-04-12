class RenameOrder < ActiveRecord::Migration
  def change
    rename_column :workcamp_assignments, :order, :position
  end
end
