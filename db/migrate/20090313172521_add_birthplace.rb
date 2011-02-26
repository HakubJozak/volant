class AddBirthplace < ActiveRecord::Migration
  def self.up
    add_column :volunteers, :birthplace, :string
  end

  def self.down
    remove_column :volunteers, :birthplace
  end
end
