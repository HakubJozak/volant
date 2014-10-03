class EmailContactsController < ApplicationController
  respond_to :json

  before_action :set_email_contact, only: [:show, :edit, :update, :destroy]


  # POST /email_contacts
  def create
    @email = EmailContact.new(email_contact_params)

    if @email.save
      redirect_to @email, notice: 'Email contact was successfully created.'
    else
      render :new
    end
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
    # Use callbacks to share common setup or constraints between actions.
    def set_email_contact
      @email = EmailContact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def email_contact_params
      params[:email_contact].permit(:name, :address, :kind, :active, :organization_id, :notes)
    end
end
