class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :code, :limit => 2, :null => false
      t.string :name_cz
      t.string :name_en

      t.timestamps
    end
  end

  def self.down
    drop_table :countries
  end
end
