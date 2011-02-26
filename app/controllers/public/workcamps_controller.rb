class Public::WorkcampsController < Public::BaseController

  layout 'public'

  def index
    # TODO - cache
    # @aims = WorkcampIntention.find(:all, :order => 'code')
    # @countries = Country.find(:all, :order => 'name_cz')
    @search = Workcamp.search(params[:search])
    @workcamps = @search.paginate(:page => (params[:page] || 1))
  end

  # TODO - move!
  def map
    Countries.all
    render :layout => false
  end

end
