# -*- coding: utf-8 -*-
# FIXME - move to Outgoing module
class Volunteer < Person

  CSV_FIELDS = %w(firstname lastname age gender email phone birthdate birthnumber nationality occupation city contact_city)

  include CzechUtils

  create_date_time_accessors

  has_many :apply_forms, :class_name => 'Outgoing::ApplyForm', validate: false

  scope :named, -> { where('rejected IS NULL') }

  def self.find_by_name_like(text)
    search = "%#{text.downcase}%"
    Volunteer.where("lower(lastname) LIKE ? or lower(firstname) LIKE ?", search, search).order('lastname ASC, firstname ASC').limit(15)
  end

  # Depending on hash parameters supplied tries either to:
  #
  # 1) find a volunteer by birthnumber, first name and lastname
  # 2) updates its parameters if found, otherwise creates a new volunteer
  # 3) returns created/updated volunteer together with code of action: :updated/:created/:created_but_uncertain
  #
  # TODO - move to lib
  def self.create_or_update(params)
    raise "no_birthnumber" unless params.has_key? 'birthnumber'
    raise "no_firstname" unless params.has_key? 'firstname'
    raise "no_lastname" unless params.has_key? 'lastname'

    found = Volunteer.find_by_birthnumber(params["birthnumber"])

    if found == nil
      [ Volunteer.new(params), :created ]
    elsif found.has_same_name?(params["firstname"], params["lastname"])
      found.attributes = params
      [ found, :updated ]
    else
      [ Volunteer.new(params), :created_but_uncertain ]
    end
  end

  # Compares supplied name with current, ignoring case and diacritics
  def has_same_name?(first, last)
    is_same_word(first,self.firstname) and is_same_word(last, self.lastname)
  end

  private

  # Returns true if the two words 'equals', ignoring diacritics and case
  def is_same_word(a,b)
    a = strip_cs_chars(a).downcase
    b = strip_cs_chars(b).downcase
    a == b
  end


end

# == Schema Information
#
# Table name: people
#
#  id                  :integer          not null, primary key
#  firstname           :string(255)      not null
#  lastname            :string(255)      not null
#  gender              :string(255)      not null
#  old_schema_key      :integer
#  email               :string(255)
#  phone               :string(255)
#  birthdate           :date
#  birthnumber         :string(255)
#  nationality         :string(255)
#  occupation          :string(255)
#  account             :string(255)
#  emergency_name      :string(255)
#  emergency_day       :string(255)
#  emergency_night     :string(255)
#  speak_well          :string(255)
#  speak_some          :string(255)
#  special_needs       :text
#  past_experience     :text
#  comments            :text
#  created_at          :datetime
#  updated_at          :datetime
#  fax                 :string(255)
#  street              :string(255)
#  city                :string(255)
#  zipcode             :string(255)
#  contact_street      :string(255)
#  contact_city        :string(255)
#  contact_zipcode     :string(255)
#  birthplace          :string(255)
#  type                :string(255)      default("Volunteer"), not null
#  workcamp_id         :integer
#  country_id          :integer
#  note                :text
#  organization_id     :integer
#  passport_number     :string(255)
#  passport_issued_at  :date
#  passport_expires_at :date
#
