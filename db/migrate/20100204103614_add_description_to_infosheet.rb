class AddDescriptionToInfosheet < ActiveRecord::Migration
  def self.up
    add_column :infosheets, :notes, :text
  end

  def self.down
    remove_columns :infosheets, :notes
  end
end
