class ImportChangeSerializer < ApplicationSerializer
  has_one :workcamp, embed: :id, include: false
  readonly_attributes :id
  writable_attributes :field, :value
end

# == Schema Information
#
# Table name: import_changes
#
#  id          :integer          not null, primary key
#  field       :string(255)      not null
#  value       :text             not null
#  diff        :text
#  workcamp_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#
