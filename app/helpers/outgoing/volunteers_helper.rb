module Outgoing
  module VolunteersHelper
    include TaggableHelper

    def age_column(volunteer)
      result = ''
      result += icon('birthday', I18n.translate('txt.has_birthday'), true) if volunteer.has_birthday?
      result += volunteer.age.to_s
    end

    def email_column(record)
      return '-' unless record.email
      email_link(record.email)
    end

  end
end
