class V1::CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :triple_code, :region, :country_zone_id, :country_zone_name

  def name
    # hard-wired English for now
    object.name_en
  end

  def country_zone_name
    object.country_zone.try(:name_en)
  end

end
