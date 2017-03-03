class VefsController < ApplicationController

  before_action :find_workcamp

  def create
    importer = Import::VefImporter.new(vef_file)
    participant = importer.import(@workcamp)

    if participant.valid?
      render json: participant.apply_form,
             serializer: ApplyFormSerializer
    else
      render json: { errors: participant.errors.full_messages }, status: 422
    end
    
    # if @attachment.save
    #   render json: @attachment, serializer: AttachmentSerializer
    # else
    #   render json: { errors:  @attachment.errors }, status: 422
    # end
  end

  private

  def import

  end

  def vef_file
    params.require(:vef)
  end

  def find_workcamp
    @workcamp = Workcamp.find(params[:workcamp_id])
  end
end
