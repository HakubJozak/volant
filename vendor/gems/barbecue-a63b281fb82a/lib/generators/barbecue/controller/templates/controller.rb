<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"



<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  respond_to :json

  before_action :find_<%= singular_name %>, except: [:index,:create]

  # GET <%= route_url %>
  def index
    if ids = params.permit(ids: [])[:ids]
      <%= plural_name %> = <%= orm_class %>.find(ids)
    else  
      <%= plural_name %> = <%= orm_class.all(model_class_name) %>
      render json: <%= plural_name %>, each_serializer: <%= serializer_class_name %>, meta: { pagination: pagination_info(<%= plural_name %>) }
    end
  end

  # GET <%= route_url %>/1
  def show
    render json: @<%= singular_name %>, serializer: <%= serializer_class_name %>
  end

  # POST <%= route_url %>
  def create
    @<%= singular_name %> = <%= orm_class.build(model_class_name, "#{singular_name}_params") %>
    if @<%= singular_name %>.save
      render json: @<%= singular_name %>, serializer: <%= serializer_class_name %>
    else
      render json: { errors:  @<%= singular_name %>.errors }, status: 422
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= singular_name %>.update(<%= singular_name %>_params)
      render json: @<%= singular_name %>, serializer: <%= serializer_class_name %>
    else
      render json: { errors:  @<%= singular_name %>.errors }, status: 422
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= singular_name %>.destroy
    head :no_content
  end

  private

  def find_<%= singular_name %>
    @<%= singular_name %> = <%= orm_class.find(model_class_name, "params[:id]") %>
  end

  def <%= "#{singular_name}_params" %>
    params.require(:<%= singular_name %>).permit()
  end
end
<% end -%>
