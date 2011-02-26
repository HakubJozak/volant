class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.integer :participant_id, :references => :people
      t.integer :workcamp_id

      t.timestamps
    end
  end

  def self.down
    drop_table :participations
  end
end
