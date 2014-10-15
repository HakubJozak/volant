class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :default_format_json

  def pagination_info(scope)
    {
      total: scope.total_count,
      total_pages: scope.total_pages,
      relevant_pages: relevant_pages(scope),
      current_page: current_page
    }
  end

  def current_page
    params[:p] || 1
  end

  def default_format_json
    if request.headers["HTTP_ACCEPT"].nil? && params[:format].nil?
      request.format = "json"
    end
  end

  private

  def relevant_pages(scope)
    paginator = Kaminari::Helpers::Paginator.new(nil, current_page: scope.current_page, total_pages: scope.total_pages, per_page: scope.limit_value)
    pages = paginator.each_relevant_page {}
    add_dots(pages).flatten
  end

  def add_dots(a)
    last = a[0] - 1

    b = a.map do |p|
      if p == last + 1
        last = p
        p
      else
        last = p
        ['...',p]
      end
    end
  end

end
