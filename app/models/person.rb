class Person < ActiveRecord::Base
  MALE = 'm'
  FEMALE = 'f'

  acts_as_taggable

  validates_inclusion_of :gender, :in => %w( m f )

  def name
    "#{lastname} #{firstname}"
  end

  def male?
    gender == Person::MALE
  end

  def female?
    not male?
  end

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

  # http://www.jonathansng.com/ruby-on-rails/calculate-age-in-rails-with-a-birthday/
  def age(today = nil)
    return '?' unless birthdate

    today ||= Date.today
    age = today.year - birthdate.year
    age -= 1 if birthdate > today.years_ago(age)
    age
  end

  def has_birthday?
    (not birthdate.nil?) and (Date.today.day == birthdate.day) and  (Date.today.month == birthdate.month)
  end


end
