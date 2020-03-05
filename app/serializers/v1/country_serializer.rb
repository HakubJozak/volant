class V1::CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :name_cz, :code, :triple_code, :region,
             :country_zone_id, :country_zone_name,
             :continent,
             :workcamps_count, :ltv_count

  def name
    # hard-wired English for now
    object.name_en
  end

  def continent
    object.country_zone.try(:continent)
  end

  def country_zone_name
    object.country_zone.try(:name_en)
  end

  def workcamps_count
    object.free_workcamps_count
  end


  def ltv_count
    object.free_ltvs_count
  end


end
