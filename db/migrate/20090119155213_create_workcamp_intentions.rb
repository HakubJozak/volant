class CreateWorkcampIntentions < ActiveRecord::Migration
  def self.up
    create_table :workcamp_intentions do |t|
      t.string :code, :null => false
      t.string :description_cz, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :workcamp_intentions
  end
end
