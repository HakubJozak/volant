class CreateNetworks < ActiveRecord::Migration
  def self.up
    create_table :networks do |t|
      t.string :name
      t.string :web

      t.timestamps
    end
  end

  def self.down
    drop_table :networks
  end
end
