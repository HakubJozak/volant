class Organization < ActiveRecord::Base

  has_many :workcamps, dependent: :destroy, validate: false
  belongs_to :country
  validates_presence_of :name, :code, :country

  has_many :partnerships, dependent: :destroy
  # has_many :email_contacts
  has_many :emails, class_name: 'EmailContact', dependent: :destroy
  has_many :networks, through: :partnerships, validate: false

  accepts_nested_attributes_for :networks

  # TODO: same as Workcamp.query - merge?
  scope :query, lambda { |query|
    fuzzy_like(query,'organizations.name','organizations.code','countries.name_en')
  }

  # Delegates for Export::Excel
  def country_zone
    country.country_zone.try(:name_en)
  end

  def country_region
    country.region
  end

  def country_name
    country.name_en
  end

  ## TODO - cache
  def self.default_organization
    Organization.find_by_code(Rails.application.config.default_organization_code)
  end

end
