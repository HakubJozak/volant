class OrganizationSerializer < ApplicationSerializer
  has_one :country, embed: :ids, include: true
  has_many :email_contacts, embed: :ids, include: true
  has_many :networks, embed: :ids, include: true, serializer: NetworkSerializer

  attributes :id, :name, :code,
    :outgoing_email,  :incoming_email,  :ltv_email,
    :address,  :contact_person,  :phone,  :mobile,  :fax,  :website

  def outgoing_email
    email_contacts.outgoing.first.address
  end

  def incoming_email
    email_contacts.incoming.first.address
  end

  def ltv_email
    email_contacts.ltv.first.address
  end  
  
  def email_contacts
    object.emails
  end
end
