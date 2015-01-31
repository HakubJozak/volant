class UsersController < ApplicationController

  respond_to :json
  before_action :find, only: [ :update, :destroy ]

  def create
    user = User.new(user_params)

    if user.save
      respond_with(user)
    else
      render_error(user)
    end
  end

  def destroy
    @user.destroy
    respond_with @user
  end

  def update
    if @user.update(user_params)
      respond_with @user
    else
      render_error(@user)
    end
  end

  def index
    respond_with User.all
  end

  private

  def find
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email,:password,:password_confirmation, :first_name, :last_name)
  end
end
