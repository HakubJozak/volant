class CreateVocatives < ActiveRecord::Migration
  def change
    create_table :vocatives do |t|
      t.string :type, :limit => 1
      t.string :nominative
      t.string :vocative

      t.timestamps null: false
    end

    add_index :vocatives, [:type, :nominative]
  end
end
