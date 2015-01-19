class V1::CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :triple_code, :region,
             :country_zone_id, :country_zone_name,
             :workcamp_count, :ltv_count

  def name
    # hard-wired English for now
    object.name_en
  end

  def country_zone_name
    object.country_zone.try(:name_en)
  end

  def workcamp_count
    object.workcamps.published.count
  end

  def ltv_count
    object.ltv_projects.published.count
  end

  
end
