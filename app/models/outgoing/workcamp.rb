module Outgoing
  class Workcamp < ::Workcamp
    create_date_time_accessors

    def open_for_application
      from.nil? || from >= Time.now.to_date
    end

  end
end
