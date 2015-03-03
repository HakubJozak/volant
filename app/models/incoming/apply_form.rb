module Incoming
  class ApplyForm < ::ApplyForm
    # belongs_to :participant, :foreign_key => 'volunteer_id', :class_name => 'Incoming::Participant'
    alias :participant :volunteer

    def toggle_confirmed
      toggle_date(:confirmed)
    end

    def confirmed?
      !self.confirmed.nil?
    end

    def confirm
      self.confirmed = Time.zone.now
    end
  end
end
