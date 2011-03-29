class CreateImportChanges < ActiveRecord::Migration
  def self.up
    create_table :import_changes do |t|
      t.string :field, :null => false
      t.text :value, :null => false
      t.text :diff
      t.integer :workcamp_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :import_changes
  end
end
