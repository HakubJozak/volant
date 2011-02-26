require "#{RAILS_ROOT}/app/models/incoming/participant"

module Incoming
  module ParticipantsHelper

    def status_column(participant)
      if participant.cancelled?
        icon('cancelled', Participant.human_attribute_name('cancelled'), true)
      else
        icon('active', Participant.human_attribute_name('active'), true)
      end
    end

    def list_row_class(participant)
      if participant.cancelled?
        'cancelled'
      end
    end  

    def lastname_column(participant)
      participant.lastname.upcase
    end

    def incoming_organization_column(record)
      if record.organization
        link_to icon('email_go', record.organization.name), "mailto:#{record.organization.email(:incoming)}"
      end
    end
  end
end
