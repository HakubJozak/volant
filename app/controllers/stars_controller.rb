class StarsController < ApplicationController
  respond_to :json

  def create
    record = model.find(star_params[:id])
    record.update_column(:starred, star_params[:value])
    # TODO: render just 'starred' attribute change
    render json: record, root: model.to_s.downcase
  end

  private

  def star_params
    params.require(:star).permit(:model,:id,:value)
  end

  def model
    case star_params[:model]
    when 'workcamp' then Workcamp
    when 'apply_form' then ApplyForm
#    when 'volunteer' then Volunteer
    else raise "Cannot star model #{params.inspect}"
    end
  end
end
