class CountrySerializer < Barbecue::BaseSerializer
  writable_attributes :name_en, :name_cz, :code, :triple_code, :region, :zone
  readonly_attributes :id
end
