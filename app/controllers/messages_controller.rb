class MessagesController < ApplicationController
  respond_to :json

  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  def index
    @messages = Message.all
    respond_with(@messages)
  end

  # POST /messages
  def create
    @message = Message.new(message_params)
    @message.save
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
    params.require(:message).permit(MessageSerializer.public_attributes)
  end
end
