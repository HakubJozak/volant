Factory.define :workcamp_assignment, :class => Outgoing::WorkcampAssignment do |a|
  a.sequence(:order) { |n| n }
  a.association :apply_form
  a.workcamp { |wc| wc.association(:outgoing_workcamp) }
end
