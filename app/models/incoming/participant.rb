# TODO - rather should be based on ApplyForm, as it is generally a VEF
class Incoming::Participant < Person

  belongs_to :country
  belongs_to :organization
  belongs_to :workcamp, :class_name => 'Incoming::Workcamp'
  has_one :apply_form, :dependent => :destroy, :class_name => 'Incoming::ApplyForm', :foreign_key => 'volunteer_id', :autosave => true
  delegate :cancelled?, :cancel,:confirmed?, :confirm, :to => :apply_form

  validates_presence_of :country
  validates_presence_of :organization

  scope :females, -> { where(gender: Person::FEMALE) }
  scope :males, -> { where(gender: Person::MALE) }
  scope :not_cancelled, -> { where('cancelled IS NULL').joins(:apply_form) }
  scope :cancelled, -> { where('cancelled IS NOT NULL').joins(:apply_form) }

  [ :general_remarks, :motivation, :cancelled ].each do |attr|
    delegate attr, :"#{attr.to_s}=", :to => :apply_form
  end

  # def to_label
  #   "#{lastname}(#{country.name})"
  # end
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
