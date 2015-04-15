class BookingSerializer < ActiveModel::Serializer
  attributes :id, :gender, :workcamp_id, :expires_at
  has_one :country, embed: :ids, include: true
  has_one :organization, embed: :ids, include: true, serializer: OrganizationSerializer  
end
