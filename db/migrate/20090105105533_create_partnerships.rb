class CreatePartnerships < ActiveRecord::Migration
  def self.up
    create_table :partnerships do |t|
      t.string :description
      t.integer :network_id
      t.integer :organization_id

      t.timestamps
    end
  end

  def self.down
    drop_table :partnerships
  end
end
