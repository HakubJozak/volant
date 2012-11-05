# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  firstname       :string(255)      not null
#  lastname        :string(255)      not null
#  gender          :string(255)      not null
#  old_schema_key  :integer
#  email           :string(255)
#  phone           :string(255)
#  birthdate       :date
#  birthnumber     :string(255)
#  nationality     :string(255)
#  occupation      :string(255)
#  account         :string(255)
#  emergency_name  :string(255)
#  emergency_day   :string(255)
#  emergency_night :string(255)
#  speak_well      :string(255)
#  speak_some      :string(255)
#  special_needs   :text
#  past_experience :text
#  comments        :text
#  created_at      :datetime
#  updated_at      :datetime
#  fax             :string(255)
#  street          :string(255)
#  city            :string(255)
#  zipcode         :string(255)
#  contact_street  :string(255)
#  contact_city    :string(255)
#  contact_zipcode :string(255)
#  birthplace      :string(255)
#  type            :string(255)      default("Volunteer"), not null
#  workcamp_id     :integer
#  country_id      :integer
#  note            :text
#  organization_id :integer
#

class Person < ActiveRecord::Base
  MALE = 'm'
  FEMALE = 'f'

  acts_as_taggable
  enforce_schema_rules rescue nil
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
