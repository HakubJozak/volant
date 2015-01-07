class AttachmentsController < ApplicationController
  respond_to :json

  before_action :find_attachment, except: [:index,:create]

  # GET /attachments
  def index
    @attachments = Attachment.all
    render json: @attachments, each_serializer: AttachmentSerializer
  end

  # GET /attachments/1
  def show
    render json: @attachment, serializer: AttachmentSerializer
  end

  # POST /attachments
  def create
    @attachment = Attachment.new(attachment_params)

    if @attachment.save
      render json: @attachment, serializer: AttachmentSerializer
    else
      render json: { errors:  @attachment.errors }, status: 422
    end
  end

  # PATCH/PUT /attachments/1
  def update
    if @attachment.update(attachment_params)
      render json: @attachment, serializer: AttachmentSerializer
    else
      render json: { errors:  @attachment.errors }, status: 422
    end
  end

  # DELETE /attachments/1
  def destroy
    @attachment.destroy
    head :no_content
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:file,:message_id)
  end
end
