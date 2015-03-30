module Outgoing
  class Workcamp < ::Workcamp
    create_date_time_accessors

    validates :begin, presence: true
    validates :end, presence: true
  end
end
