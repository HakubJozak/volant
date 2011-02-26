class AddEmailKind < ActiveRecord::Migration
  def self.up
    add_column :email_contacts, :kind, :string
  end

  def self.down
    remove_columns :email_contacts, :kind
  end
end
