class WorkcampIntention < ActiveRecord::Base
  has_and_belongs_to_many :workcamps
  validates :code, presence: true
  validates :description_en, presence: true
  validates :description_cz, presence: true

  def to_label
    "#{code} - #{description_cz}"
  end

  def to_s
    code
  end
end
