module Outgoing
  class Workcamp < ::Workcamp
    create_date_time_accessors

    has_many :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::WorkcampAssignment'
    has_many :apply_forms, through: :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::ApplyForm'
  end
end
