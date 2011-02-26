class FixParticipants < ActiveRecord::Migration
  def self.up
    Incoming::Participant.all.each do |p|
      p.create_apply_form
    end
  end

  def self.down
  end
end
