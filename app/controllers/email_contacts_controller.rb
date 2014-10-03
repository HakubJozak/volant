class EmailContactsController < ApplicationController
  respond_to :json

  before_action :set_email_contact, only: [:show, :edit, :update, :destroy]


  # POST /email_contacts
  def create
    @email = EmailContact.new(email_contact_params)
    @email.save
    respond_with(@email)
  end

  # PATCH/PUT /email_contacts/1
  def update
    @email.update(email_contact_params)
    respond_with(@email)
  end

  # DELETE /email_contacts/1
  def destroy
    @email.destroy
    respond_with(@email)
  end

  private

  def set_email_contact
    @email = EmailContact.find(params[:id])
  end

  # TODO SECURITY: scope by organization, scope organization by logged in user!
  def email_contact_params
    params[:email_contact].permit(:name, :address, :kind, :active, :organization_id, :notes)
  end
end
