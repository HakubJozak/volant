class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :default_format_json
  serialization_scope :current_user

  private

  def pagination_info(scope)
    {
      total: scope.total_count,
      per_page: scope.size,
      total_pages: scope.total_pages,
      pagination_bits: Paginator.new(scope,left: 2,right: 2).pagination_bits,
      current_page: current_page
    }
  end

  def per_page
    params[:per_page] || params[:per] || 10
  end

  def current_page
    params[:p] || params[:page] || 1
  end

  def current_order_direction
    if ['true',true,1].include?(params[:asc])
      'asc'
    else
      'desc'
    end
  end

  def current_organization
    # TODO: take the code from organization
    @current_organization ||= Organization.find_by_code('SDA')
  end

  def current_year
    params[:year] || nil
  end

  def add_year_scope(search)
    if year = params[:year]
      if year.to_i > 0
        search = search.year(year)
      end
    end

    search
  end

  def workcamp_type(type)
    case type.try(:downcase)
    when 'incoming' then Incoming::Workcamp
    when 'ltv' then Ltv::Workcamp
    when 'outgoing' then Outgoing::Workcamp
    else Workcamp
    end
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

  # HACK - dealing with [] being converted to nil Rails behaviour
  def replace_nil_by_empty_array(hash,name)
    hash[name] = [] if hash[name].nil?
    hash
  end

end
