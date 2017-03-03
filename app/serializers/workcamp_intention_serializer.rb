class WorkcampIntentionSerializer < ApplicationSerializer
  readonly_attributes :id
  writable_attributes :code, :description_en, :description_cz
end

# == Schema Information
#
# Table name: workcamp_intentions
#
#  id             :integer          not null, primary key
#  code           :string(255)      not null
#  description_cz :string(255)      not null
#  created_at     :datetime
#  updated_at     :datetime
#  description_en :string(255)
#
