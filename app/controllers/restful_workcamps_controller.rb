class RestfulWorkcampsController < RestfulController

  # def index
  #   if params[:page]
  #     page = params[:page]
  #     per_page = params[:per_page]
  #     query = params[:query]

  #     @workcamps = WorkcampSearch::find_by_query(query, page, per_page)
  #   else
  #     @workcamps = Workcamp.find :all, :limit => 15, :include => :country, :order => '"begin" DESC'
  #   end

  #   respond_to do |format|
  #     format.xml  { render :xml => @workcamps.to_xml(:include => [ :country, :intentions ]) }
  #   end
  # end

  # def total
  #   respond_to do |format|
  #     format.xml  { render :xml => { :total => WorkcampSearch::total(params[:query]) } }
  #   end
  # end

  # def show
  #   @workcamp = Workcamp.find(params[:id])

  #   respond_to do |format|
  #     format.xml  { render :xml => @workcamp.to_xml(:include => [ :country, :intentions ]) }
  #   end
  # end

end

