class OrganizationSerializer < ApplicationSerializer
  has_one :country, embed: :ids, include: true
  has_many :email_contacts, embed: :ids, include: true
  has_many :networks, embed: :ids, include: true, serializer: NetworkSerializer

  attributes :id, :name, :code, :description,
    :outgoing_email,  :incoming_email,  :ltv_email,
    :address,  :contact_person,  :phone,  :mobile,  :fax,  :website

  def outgoing_email
    emails('OUTGOING')
  end

  def incoming_email
    emails('INCOMING')
  end

  def ltv_email
    emails('LTV')
  end

  def email_contacts
    object.emails
  end

  private

  def emails(kind)
    # benefits from eager loading
    object.emails.find { |a| a.kind == kind }.try(:address)
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id             :integer          not null, primary key
#  country_id     :integer          not null
#  name           :string(255)      not null
#  code           :string(255)      not null
#  address        :string(255)
#  contact_person :string(255)
#  phone          :string(255)
#  mobile         :string(255)
#  fax            :string(255)
#  website        :string(2048)
#  created_at     :datetime
#  updated_at     :datetime
#
