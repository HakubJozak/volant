class CreateEmailContacts < ActiveRecord::Migration
  def self.up
    create_table :email_contacts do |t|
      t.boolean :active, :default => false
      t.string :address, :null => false
      t.string :name
      t.string :notes
      t.integer :organization_id

      t.timestamps
    end
  end

  def self.down
    drop_table :email_contacts
  end
end
