Factory.define :workcamp_assignment, :class => Outgoing::WorkcampAssignment do |a|
  a.association :apply_form
  a.workcamp { |wc| wc.association(:outgoing_workcamp) }
end

Factory.define :accepted_assignment, parent: :workcamp_assignment do |a|
  a.accepted 1.day.ago
end


