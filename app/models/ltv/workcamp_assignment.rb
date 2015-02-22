module Ltv
  class WorkcampAssignment < ::Outgoing::WorkcampAssignment
    belongs_to :apply_form, :class_name => 'Ltv::ApplyForm'
    belongs_to :workcamp, :class_name => 'Ltv::Workcamp'
  end
end
