class Internal::EmailTemplatesController < Internal::BaseController
  
  include MinimalResponders

  before_action :set_email_template, only: [:show, :edit, :update, :destroy]

  # GET /email_templates
  def index
    @email_templates = EmailTemplate.order(:title).all
  end

  def show
  end

  def new
    @email_template = EmailTemplate.new
  end

  # POST /email_templates
  def create
    @email_template = EmailTemplate.new(email_template_params)

    @email_template.save
    respond_with @email_template, location: index_path
  end

  def edit    
  end

  # PATCH/PUT /email_templates/1
  def update
    @email_template.update(email_template_params)
    respond_with @email_template, location: index_path    
  end

  # DELETE /email_templates/1
  def destroy
    respond_with @email_template.tap(&:destroy), location: index_path    
  end

  private

    def index_path
      internal_email_templates_path
    end

    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    def email_template_params
      params.require(:email_template).permit(:title, :subject, :body, :to, :from, :cc, :bcc)
    end
end
