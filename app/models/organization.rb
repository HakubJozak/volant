class Organization < ActiveRecord::Base

#  has_many :email_contacts
  has_many :workcamps
  belongs_to :country
  validates_presence_of :name, :code, :country

  has_many :partnerships, :dependent => :destroy
  has_many :emails, :class_name => 'EmailContact', :dependent => :destroy
  has_many :networks, :through => :partnerships

  # TODO: same as Workcamp.query - merge?
  scope :query, lambda { |q|
    table = self.arel_table
    arel = table[:name].matches("%#{query}%").or(table[:code].matches("%#{query}%"))
    where(arel)
  }

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
    Organization.find_by_code(Rails.application.config.default_organization_code)
  end

end
