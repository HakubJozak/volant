class RemoveOldColumns < ActiveRecord::Migration
  def change
    remove_column :workcamps, :old_schema_key, :string
    remove_column :workcamps, :sci_id, :string
    remove_column :workcamps, :sci_code, :string        
  end
end
