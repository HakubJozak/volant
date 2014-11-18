class V1::OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :website
  has_one :country, serializer: V1::CountrySerializer
end
