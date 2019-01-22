class RenameTypeColumnInVocative < ActiveRecord::Migration
  def change
    rename_column :vocatives, :type, :name_type
  end
end
