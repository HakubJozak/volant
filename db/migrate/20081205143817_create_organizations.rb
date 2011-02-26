class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.column :country_id, :integer, :null => false

      t.column :name, :string, :null => false, :distinct => true
      t.column :code, :string, :null => false

      t.column :address, :string
      t.column :contact_person, :string
      t.column :phone, :string
      t.column :mobile, :string
      t.column :fax, :string
      t.column :website, :string, :limit => 2048

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
