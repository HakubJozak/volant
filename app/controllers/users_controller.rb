class UsersController < ApplicationController
  respond_to :json

  def create
    user = User.new(params[:user])

    if user.save
      render json: user, status: :created
    else
      respond_with user
    end
  end

  def index
    respond_with User.all
  end
end
