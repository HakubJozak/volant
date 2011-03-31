class Organization < ActiveRecord::Base
  acts_as_commentable
  # acts_as_convertible_to_csv

  DEFAULT_ORG_CODE = 'volant.default_organization_code'

  enforce_schema_rules
#  has_many :email_contacts
  has_many :workcamps
  belongs_to :country
  validates_presence_of :country

  has_many :partnerships, :dependent => :destroy
  has_many :emails, :class_name => 'EmailContact', :dependent => :destroy
  has_many :networks, :through => :partnerships

  def self.find_all_ordered_by_countries
    Organization.find(:all, :joins => [ :country ], :order => 'countries.code ASC, organizations.name ASC')
  end

  # kinds: :incoming, :outgoing, :off
  def email(kind = :outgoing)
    contact = emails.find_by_kind(kind.to_s.upcase)
    contact ? contact.address : nil
  end

  def to_s
    name
  end

  ## TODO - cache
  def self.default_organization
    Organization.find_by_code(Volant::Config::default_organization_code)
  end

end

