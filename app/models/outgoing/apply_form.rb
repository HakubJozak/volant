module Outgoing
  class ApplyForm < ::ApplyForm
    validates_presence_of :volunteer, :fee, :motivation
  end
end
