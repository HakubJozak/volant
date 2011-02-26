class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :code, :limit => 2
      t.string :triple_code, :limit => 3, :null => false
      t.string :name_cz
      t.string :name_en, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :languages
  end
end




