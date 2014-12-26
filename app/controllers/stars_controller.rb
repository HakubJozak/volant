class StarsController < ApplicationController
  respond_to :json

  def create
    record = model.find(star_params[:id])

    if star_params[:value] == 'true'
      record.add_star(current_user)
    else
      record.remove_star(current_user)
    end

    # TODO: render just 'starred' attribute change
    render json: record, root: model.to_s
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
