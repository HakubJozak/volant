class MessagesController < ApplicationController
  respond_to :json

  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages4
  def index
    @messages = Message.all
    respond_with(@messages)
  end

  def show
    respond_with(@message)
  end

  # POST /messages
  def create
#    puts params
    apply_form = ApplyForm.find(params[:message][:apply_form_id])
    @message = apply_form.build_message(message_params)
    @message.user = current_user
    #    @message.save
    apply_form.save
    respond_with(@message)
  end

  # PATCH/PUT /messages/1
  def update
    @message.update(message_params)
    respond_with(@message)
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
    respond_with(@message)
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    if params[:message]
      params[:message].delete(:sent_at)
    end

    params.require(:message).permit(MessageSerializer.public_attributes)
  end
end
