class DeleteParticipations < ActiveRecord::Migration
  def self.up
    drop_table :participations
    add_column :people, :workcamp_id, :integer
  end

  def self.down
  end
end
