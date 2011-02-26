class AddNoteToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :note, :text
  end

  def self.down
    remove_columns :people, :note
  end
end
