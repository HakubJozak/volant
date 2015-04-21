class BookingSerializer < ActiveModel::Serializer
  attributes :id, :gender,:expires_at, :is_expired
  has_one :country, embed: :ids, include: true
  has_one :workcamp, embed: :ids, include: true  
  has_one :organization, embed: :ids, include: true, serializer: OrganizationSerializer

  def is_expired
    object.expired?
  end
end
