class Person < ActiveRecord::Base
  MALE = 'm'
  FEMALE = 'f'

  include PersonalMethods
  
  acts_as_taggable

  validates_inclusion_of :gender, :in => %w( m f )
  validates :birthnumber, format: { with: /\A[0-9]+\z/, allow_blank: true}
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }


  def self.gender_attribute_name(gender)
    if gender == Person::MALE
      I18n.translate(:male)
    else
      I18n.translate(:female)
    end
  end

  def gender_sufix
    self.male? ? "males" : "females"
  end


end
