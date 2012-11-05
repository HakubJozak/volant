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

class WorkcampIntention < ActiveRecord::Base
  has_and_belongs_to_many :workcamps

  def to_label
    "#{code} - #{description_cz}"
  end

  def to_s
    code
  end
end
