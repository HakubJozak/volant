class Outgoing::WorkcampAssignmentSerializer < ::WorkcampAssignmentSerializer
end

# == Schema Information
#
# Table name: workcamp_assignments
#
#  id            :integer          not null, primary key
#  apply_form_id :integer
#  workcamp_id   :integer
#  position      :integer          not null
#  accepted      :datetime
#  rejected      :datetime
#  asked         :datetime
#  infosheeted   :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  confirmed     :datetime
#
