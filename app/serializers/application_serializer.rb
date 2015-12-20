class ApplicationSerializer < Barbecue::BaseSerializer
  def starred
    current_user.has_starred?(object)
  end

  def current_account
    current_user.account
  end  
end
