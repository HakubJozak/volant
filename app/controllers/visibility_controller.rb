class VisibilityController < ActionController::Base

  before_filter :create_cart

  def show_menu_item
    @hcart.show(params[:id])
    render :inline => ''
  end

  def hide_menu_item
    @hcart.hide(params[:id])
    render :inline => ''
  end

  protected

  def create_cart
    session[:hcart] ||= HiddenCart.new
    @hcart = session[:hcart]
  end
end
