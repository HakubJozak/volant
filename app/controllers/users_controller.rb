class UsersController < ApplicationController

  respond_to :json
  before_action :find, only: [ :update, :destroy ]

  def create
    user = User.new(params[:user])

    if user.save
      render json: user, status: :created
    else
      respond_with user
    end
  end

  def update
    @user.update(user_attributes)
    respond_with @user
  end

  def index
    respond_with User.all
  end

  private

  def find
    @user = User.find(params[:id])
  end

  def user_attributes
    params.require(:user).permit(:email,:password,:password_confirmation)
  end
end
