class V1::CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :triple_code, :region,
             :country_zone_id, :country_zone_name,
  :workcamps_count, :ltv_count

  def name
    # hard-wired English for now
    object.name_en
  end

  def country_zone_name
    object.country_zone.try(:name_en)
  end

  def workcamps_count
    object.workcamps.published(Account.current.season_end).count
  end

  def ltv_count
    object.ltv_projects.published(Account.current.season_end).count
  end


end
