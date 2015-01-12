class CountrySerializer < ApplicationSerializer
  has_one :country_zone, embed: :ids, include: true
  attributes :name_en, :name_cz, :code, :triple_code, :region, :id
end
