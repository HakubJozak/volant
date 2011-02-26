module Incoming
  class ApplyForm < ::ApplyForm
    belongs_to :participant, :foreign_key => 'volunteer_id', :class_name => 'Incoming::Participant'
  end
end
