class ApplicationSerializer < Barbecue::BaseSerializer
  def starred
    current_user.has_starred?(object)

  end
end
