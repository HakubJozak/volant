class Incoming::Booking < ActiveRecord::Base
  belongs_to :workcamp, :class_name => 'Incoming::Workcamp'
  belongs_to :organization
  belongs_to :country
  validates_presence_of :gender

  scope :females, -> { where(gender: Person::FEMALE) }
  scope :males, -> { where(gender: Person::MALE) }


  def male?
    gender == 'm'
  end

  # def to_label
  #   label = I18n.translate(:male) : I18n.translate(:female)
  #   label += (country.name) if country
  # end

end
