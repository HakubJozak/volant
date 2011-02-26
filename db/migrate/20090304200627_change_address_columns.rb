class ChangeAddressColumns < ActiveRecord::Migration
  def self.up
    remove_column :volunteers, :address
    remove_column :volunteers, :contact_address

    add_column :volunteers, :street, :string
    add_column :volunteers, :city, :string
    add_column :volunteers, :zipcode, :string

    add_column :volunteers, :contact_street, :string
    add_column :volunteers, :contact_city, :string
    add_column :volunteers, :contact_zipcode, :string
  end

  def self.down
    add_column :volunteers, :address, :text
    add_column :volunteers, :contact_address, :text

    remove_column :volunteers, :street
    remove_column :volunteers, :city
    remove_column :volunteers, :zipcode

    remove_column :volunteers, :contact_street
    remove_column :volunteers, :contact_city
    remove_column :volunteers, :contact_zipcode
  end
end
