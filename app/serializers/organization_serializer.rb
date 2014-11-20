class OrganizationSerializer < Barbecue::BaseSerializer
  has_one :country, embed: :ids, include: true
  has_many :email_contacts, embed: :ids, include: true
  has_many :workcamps, embed: :ids, include: false
  attributes :id, :name, :code,
             :address,
             :contact_person,
             :phone,
             :mobile,
             :fax,
             :website

  def email_contacts
    object.emails
  end
end
