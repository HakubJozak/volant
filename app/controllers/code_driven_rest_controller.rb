class CodeDrivenRestController < RestfulController

  def initialize(model)
#    super
    @model = model
  end

  def index
    unless params[:code]
      @result = @model.find :all
    else
      @result = [ @model.find_by_code(params[:code]) ]
    end

    respond_to do |format|
      format.xml  { render :xml => @result }
    end
  end

  def show
    @object = @model.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @object }
    end
  end


end
