class Ltv::ApplyForm < ::Outgoing::ApplyForm
  belongs_to :current_workcamp, foreign_key: 'current_workcamp_id_cached', class_name: 'Ltv::Workcamp'
  belongs_to :current_assignment, foreign_key: 'current_assignment_id_cached', class_name: 'Ltv::WorkcampAssignment'
  has_many :workcamps, -> { order 'workcamp_assignments."order" ASC' }, through: :workcamp_assignments, class_name: 'Ltv::Workcamp', validate: false
  has_many :workcamp_assignments, -> { order '"order" ASC' }, dependent: :delete_all, class_name: 'Ltv::WorkcampAssignment', validate: false  
end
