class Public::BaseController < ApplicationController

  layout nil
  skip_before_filter :login_required
  before_filter :set_js_id ,:only => [ :show_detail, :hide_detail ]
  before_filter :find_cart

  def show_detail
    render :update do |page|
      page[@js_id].replace :partial => 'workcamps/detail',
                          :object => Workcamp.find(params[:id]),
                          :locals => @locals
      # page[js_id].visual_effect :grow, :duration => 1.0
      page[@js_id].show
    end
  end

  def hide_detail
    render :update do |page|
      page[@js_id].visual_effect :fade
      page[@js_id].replace :partial => 'workcamps/workcamp',
                          :object => Workcamp.find(params[:id]),
                          :locals => @locals
      page << 'number_workcamps();'
    end
  end

  def rescue_action_in_public(exception)
    render :template => '/workcamps/sorry'
  end


  private

  def set_js_id
    @js_id = params[:js_id]
    @locals = { :js_id => @js_id, :prefix => params[:prefix] }
  end

  def find_cart
    @cart = (session[:cart] ||= Public::Cart.new)
  end

end
