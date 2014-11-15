class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :default_format_json

  private

  def pagination_info(scope)
    {
      total: scope.total_count,
      total_pages: scope.total_pages,
      pagination_bits: Paginator.new(scope,left: 2,right: 2).pagination_bits,
      current_page: current_page
    }
  end

  def current_page
    params[:p] || 1
  end

  def add_year_scope(search)
    if year = params[:year]
      if year.to_i > 0
        search = search.year(year)
      end
    end

    search
  end

  def default_format_json
    if request.headers["HTTP_ACCEPT"].nil? && params[:format].nil?
      request.format = "json"
    end
  end

end
