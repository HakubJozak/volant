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
    params[:p] || params[:page] || 1
  end

  def current_organization
    # TODO: take the code from organization
    @current_organization ||= Organization.find_by_code('SDA')
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

  def render_error(model)
    full = model.errors.full_messages.join('. ')
    render json: { errors: model.errors, full_message: "#{full}." }, status: 422
  end



end
