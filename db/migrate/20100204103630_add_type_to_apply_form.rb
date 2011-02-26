class AddTypeToApplyForm < ActiveRecord::Migration
  def self.up
    add_column :apply_forms, :type, :string, :null => false, :default => 'Outgoing::ApplyForm'
  end

  def self.down
    remove_columns :apply_forms, :type
  end
end
