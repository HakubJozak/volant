class EmailTemplatesController < ApplicationController
  respond_to :json

  before_action :set_email_template, only: [:show, :edit, :update, :destroy]

  # GET /email_templates
  def index
    @email_templates = EmailTemplate.order(:title).all
    respond_with(@email_templates)
  end

  def show
    respond_with(@email_template)
  end

  # POST /email_templates
  def create
    @email_template = EmailTemplate.new(email_template_params)

    if @email_template.save
      respond_with(@email_template)
    else
      render_error(@email_template)
    end

  end

  # PATCH/PUT /email_templates/1
  def update
    if @email_template.update(email_template_params)
      respond_with(@email_template)
    else
      render_error(@email_template)
    end
  end

  # DELETE /email_templates/1
  def destroy
    @email_template.destroy
    respond_with(@email_template)
  end

  private

  def set_email_template
    @email_template = EmailTemplate.find(params[:id])
  end

  def email_template_params
    params.require(:email_template).permit(:title, :subject, :body, :to, :from, :cc, :bcc)
  end
end
