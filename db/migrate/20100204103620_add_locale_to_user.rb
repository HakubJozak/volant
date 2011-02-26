class AddLocaleToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :locale, :string, :limit => 3, :default => 'en', :null => false
  end

  def self.down
    remove_columns :users, :locale
  end
end
