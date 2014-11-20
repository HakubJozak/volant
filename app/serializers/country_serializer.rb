class CountrySerializer < Barbecue::BaseSerializer
  writable_attributes :name_en, :name_cz, :code, :triple_code
  readonly_attributes :id
end
