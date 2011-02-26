class CreateWorkcampsWorkcampIntentions < ActiveRecord::Migration
  def self.up
    create_table :workcamp_intentions_workcamps, :id => false do |t|
      t.integer :workcamp_id
      t.integer :workcamp_intention_id
    end
  end

  def self.down
    drop_table :workcamp_intentions_workcamps
  end
end
