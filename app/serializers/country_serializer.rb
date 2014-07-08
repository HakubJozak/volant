class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :triple_code
end
