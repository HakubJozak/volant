class Public::CartHandlingController < Public::BaseController

  CART_CHANGE_VIEW = 'cart_change'
  COUNTRIES_CHANGE_VIEW = 'countries_change'

  def sort_workcamps
    @cart.sort(params[:cart_workcamps_tbody])
    render :nothing => true
  end

  def remove_workcamp_from_cart
    @cart.remove_workcamp Workcamp.find(params[:id])
    render :action => CART_CHANGE_VIEW
  end

  def add_workcamp_to_cart
    workcamp = Workcamp.find(params[:id])

    if workcamp
      @cart.add_workcamp workcamp
      logger.info "#{workcamp} moved to cart"
      render :action => CART_CHANGE_VIEW
    else
      logger.error "Tried to add non-existing workcamp with ID #{params[:id]}"
      redirect_to :action => :list
    end
  end

  def empty_cart
    @cart.empty!
    render :action => CART_CHANGE_VIEW
  end

  def add_country
    begin
      country = Country.find_by_code(params[:code])

      if country
        @cart.add_country(country)
        @result = :workcamp_added
      else
        @result = :no_country_there
      end
    rescue ActiveRecord::RecordNotFound
      @result = :no_workcamp_there
    end

    render :action => COUNTRIES_CHANGE_VIEW
  end

  def remove_country
    @cart.remove_country(params[:code])
    render :action => COUNTRIES_CHANGE_VIEW
  end

  def clear_countries
    @cart.clear_countries
    render :action => COUNTRIES_CHANGE_VIEW
  end

end
