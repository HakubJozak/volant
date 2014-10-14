class UsersController < ApplicationController

  respond_to :json
  before_action :find, only: [ :update, :destroy ]

  def create
    user = User.create(user_params)
    respond_with user
  end

  def destroy
    @user.destroy
    respond_with @user
  end

  def update
    @user.update(user_params)
    respond_with @user
  end

  def index
    respond_with User.all
  end

  private

  def find
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email,:password,:password_confirmation)
  end
end
