class CountrySerializer < ApplicationSerializer
  has_one :country_zone, embed: :ids, include: true
  writable_attributes :name_en, :name_cz, :code, :triple_code, :region
  readonly_attributes :id
end
