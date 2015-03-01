module Outgoing
  class ApplyForm < ::ApplyForm
    def email_template_name_for(action)
      action
    end
  end
end
