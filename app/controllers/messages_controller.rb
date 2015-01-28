class MessagesController < ApplicationController
  respond_to :json

  before_action :set_message, only: [:show, :edit, :update, :destroy, :deliver]

  def index
    search = Message.page(current_page).order('sent_at DESC NULLS FIRST,created_at DESC')

    if id = params[:user_id]
      search = search.where(user_id: id)
    end

    render json: search,
           meta: { pagination: pagination_info(search) }
  end

  def show
    respond_with(@message)
  end

  def create
    if id = params[:message][:apply_form_id]
      apply_form = ApplyForm.find(id)
      @message = apply_form.messages.build(message_params)
      @message.user = current_user
      apply_form.save
    else
      @message = Message.new(message_params)
      @message.user = current_user
      @message.save
    end

    respond_with(@message)
  end

  # PATCH/PUT /messages/1
  def update
    @message.update(message_params)
    respond_with(@message)
  end

  # PATCH/PUT /messages/1/send
  def deliver
    @message.deliver!

    if @message.apply_form
      # TODO: test this branch
      @message.apply_form.messages(false)
      payload = Payload.new(messages: [ @message],
                          apply_forms: [ @message.apply_form ],
                          workcamp_assignments: @message.apply_form.workcamp_assignments)
      render json: payload, serializer: PayloadSerializer
    else
      respond_with(@message)
    end
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
    params[:message].delete(:sent_at) if params[:message]
    params[:message][:attachments_attributes] = params[:message][:attachments]

    params.require(:message).permit(:to, :from, :cc, :bcc, :subject, :body, :html_body,
                                    :user_id, :email_template_id,  :action,
                                    :attachments_attributes => [:id, :type, :workcamp_id, :apply_form_id])
  end
end
