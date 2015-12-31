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
    workcamps_scope.free.count
  end


  def ltv_count
    ltv_projects_scope.free.count
  end

  # def free_ltv_count
  # end

  # def free_workcamps_count
  # end



  private

  def workcamps_scope
    object.workcamps.future.published(Account.current.season_end)
  end

  def ltv_projects_scope
    object.ltv_projects.future.published(Account.current.season_end)
  end


end
