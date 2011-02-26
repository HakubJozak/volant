class CreateIncomingLeaderships < ActiveRecord::Migration
  def self.up
    create_table :leaderships do |t|
      t.references :person
      t.references :workcamp
      t.timestamps
    end
  end

  def self.down
    drop_table :leaderships
  end
end
