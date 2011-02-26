class AddTagColor < ActiveRecord::Migration
  def self.up
    add_column :tags, :color, :string, :limit => 7, :null => false, :default => '#FF0000'
    add_column :tags, :text_color, :string, :limit => 7, :null => false, :default => '#FFFFFF'
    change_column :tags, :name, :string, :null => false
  end

  def self.down
    remove_column :tags, :color
    remove_column :tags, :text_color
    change_column :tags, :name, :string
  end
end
