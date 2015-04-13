Factory.define :workcamp_assignment, :class => Outgoing::WorkcampAssignment do |a|
  a.association :apply_form
  a.workcamp { |wc| wc.association(:outgoing_workcamp) }
end
