class ApplicationSerializer < Barbecue::BaseSerializer
  def starred
    object.starred?(current_user)
  end
end
