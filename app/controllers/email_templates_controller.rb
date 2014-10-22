class EmailTemplatesController < ApplicationController
  respond_to :json

  before_action :set_email_template, only: [:show, :edit, :update, :destroy]

  # GET /email_templates
  def index
    @email_templates = EmailTemplate.all
    respond_with(@email_templates)
  end

  # POST /email_templates
  def create
    @email_template = EmailTemplate.new(email_template_params)
    @email_template.save
    respond_with(@email_template)
  end

  # PATCH/PUT /email_templates/1
  def update
    @email_template.update(email_template_params)
    respond_with(@email_template)
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
    params.require(:email_template).permit(EmailTemplateSerializer.public_attributes)
  end
end
