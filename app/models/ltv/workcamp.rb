module Ltv
  class Workcamp < ::Workcamp
    has_many :workcamp_assignments, dependent: :destroy, class_name: 'Ltv::WorkcampAssignment'
    has_many :apply_forms, through: :workcamp_assignments, dependent: :destroy, class_name: 'Ltv::ApplyForm'
  end
end
