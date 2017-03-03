class BookingSerializer < ActiveModel::Serializer
  attributes :id, :gender,:expires_at, :is_expired, :workcamp_id
  has_one :country, embed: :ids, include: true
  has_one :organization, embed: :ids, include: true, serializer: OrganizationSerializer

  def is_expired
    object.expired?
  end
end

# == Schema Information
#
# Table name: bookings
#
#  id              :integer          not null, primary key
#  workcamp_id     :integer
#  organization_id :integer
#  country_id      :integer
#  gender          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  expires_at      :date
#
