require "#{Rails.root}/app/models/outgoing/workcamp_assignment"

module Outgoing
  class Workcamp < ::Workcamp
    create_date_time_accessors

  end
end
