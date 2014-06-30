class WorkcampIntention < ActiveRecord::Base
  has_and_belongs_to_many :workcamps

  def to_label
    "#{code} - #{description_cz}"
  end

  def to_s
    code
  end
end
