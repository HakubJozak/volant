# TODO - rather should be based on ApplyForm, as it is generally a VEF
class Incoming::Participant < Person

  belongs_to :country
  belongs_to :organization
  belongs_to :workcamp, :class_name => 'Incoming::Workcamp'
  has_one :apply_form, :dependent => :destroy, :class_name => 'Incoming::ApplyForm', :foreign_key => 'volunteer_id', :autosave => true
  delegate :cancelled?, :cancel, :toggle_cancelled,:confirmed?, :confirm, :to => :apply_form

  validates_presence_of :country
  validates_presence_of :organization
  validates_presence_of :apply_form

  scope :females, -> { where(gender: Person::FEMALE) }
  scope :males, -> { where(gender: Person::MALE) }
  scope :not_cancelled, -> { where('cancelled IS NULL').joins(:apply_form) }
  scope :cancelled, -> { where('cancelled IS NOT NULL').joins(:apply_form) }

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
