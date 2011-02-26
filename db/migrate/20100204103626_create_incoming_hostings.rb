class CreateIncomingHostings < ActiveRecord::Migration
  def self.up
    create_table :hostings do |t|
      t.references :workcamp
      t.references :partner

      t.timestamps
    end
  end

  def self.down
    drop_table :hostings
  end
end
