class CreateIncomingPartners < ActiveRecord::Migration
  def self.up
    create_table :partners do |t|
      t.string :name, :null => false
      t.string :contact_person
      t.string :phone
      t.string :email
      t.string :address, :limit => 2048
      t.string :website, :limit => 2048 
      t.string :negotiations_notes, :limit => 5096 
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :partners
  end
end
