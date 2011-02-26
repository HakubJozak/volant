class AddSciCode < ActiveRecord::Migration
  def self.up
    add_column :workcamps, :sci_code, :string
  end

  def self.down
    remove_columns :workcamps, :sci_code
  end
end
