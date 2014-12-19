class V1::CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :triple_code, :region, :country_zone_id

  def name
    # hard-wired English for now
    object.name_en
  end

end
