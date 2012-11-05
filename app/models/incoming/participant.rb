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

# TODO - rather should be based on ApplyForm, as it is generally a VEF
class Incoming::Participant < Person

  belongs_to :country
  belongs_to :organization
  belongs_to :workcamp, :class_name => 'Incoming::Workcamp'
  has_one :apply_form, :dependent => :destroy, :class_name => 'Incoming::ApplyForm', :foreign_key => 'volunteer_id', :autosave => true
  delegate :cancelled?, :cancel, :toggle_cancelled, :toggle_confirmed, :confirmed?, :confirm, :to => :apply_form

  validates_presence_of :country
  validates_presence_of :organization
  validates_presence_of :apply_form

  named_scope :females, :conditions => {:gender => Person::FEMALE }
  named_scope :males, :conditions => {:gender => Person::MALE }
  named_scope :not_cancelled, :joins => :apply_form, :conditions => [ 'cancelled IS NULL' ]
  named_scope :cancelled, :joins => :apply_form, :conditions => [ 'cancelled IS NOT NULL' ]

  [ :general_remarks, :motivation, :cancelled ].each do |attr|
    delegate attr, :"#{attr.to_s}=", :to => :apply_form
  end

  def after_initialize
    self.country = organization.country if organization and country.nil?
    self.apply_form = Incoming::ApplyForm.new unless apply_form
  end

  # def to_label
  #   "#{lastname}(#{country.name})"
  # end
end
