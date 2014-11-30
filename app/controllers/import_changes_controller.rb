class ImportChangesController < ApplicationController
  respond_to :json

  before_action :set_import_change, only: [:show, :edit, :update, :destroy]

  # GET /import_changes
  def index
    @import_changes = ImportChange.all
    render json: @import_changes, each_serializer: ImportChangeSerializer
  end

  # GET /import_changes/1
  def show
    render json: @import_change, serializer: ImportChangeSerializer
  end

  # PATCH/PUT /import_changes/1
  def update
    if @import_change.update(import_change_params)
      render json: @import_change, serializer: ImportChangeSerializer
    else
      render json: { errors:  @import_change.errors }, status: 422
    end
  end

  # DELETE /import_changes/1
  def destroy
    @import_change.destroy
    head :no_content
  end

  private

  def set_import_change
    @import_change = ImportChange.find(params[:id])
  end

  def import_change_params
    params.require(:import_change).permit(*ImportChangeSerializer.writable)
  end
end
