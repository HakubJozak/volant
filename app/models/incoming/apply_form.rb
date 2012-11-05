# == Schema Information
#
# Table name: apply_forms
#
#  id                           :integer          not null, primary key
#  volunteer_id                 :integer
#  fee                          :decimal(10, 2)   default(2200.0), not null
#  cancelled                    :datetime
#  general_remarks              :text
#  motivation                   :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  current_workcamp_id_cached   :integer
#  current_assignment_id_cached :integer
#  type                         :string(255)      default("Outgoing::ApplyForm"), not null
#  confirmed                    :datetime
#

module Incoming
  class ApplyForm < ::ApplyForm
    belongs_to :participant, :foreign_key => 'volunteer_id', :class_name => 'Incoming::Participant'

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
