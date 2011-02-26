class Incoming::Booking < ActiveRecord::Base
  belongs_to :workcamp, :class_name => 'Incoming::Workcamp'
  belongs_to :organization
  belongs_to :country
  validates_presence_of :gender

  named_scope :females, :conditions => {:gender => Person::FEMALE }
  named_scope :males, :conditions => {:gender => Person::MALE }


  def male?
    gender == 'm'
  end

  # def to_label
  #   label = I18n.translate(:male) : I18n.translate(:female)
  #   label += (country.name) if country
  # end
  
end
