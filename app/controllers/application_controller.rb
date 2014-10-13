class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def pagination_info(scope)
    {
      total: scope.total_count,
      total_pages: scope.total_pages,
      current_page: current_page
    }
  end

  def current_page
    params[:p] || 1
  end

end
