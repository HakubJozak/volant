class Internal::UsersController < Internal::BaseController

  include MinimalResponders

  before_action :find, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.order(:last_name)
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    user.save
    respond_with @user, location: index_path      
  end

  def update
    @user.update(user_params)
    respond_with @user, location: index_path      
  end

  def destroy
    respond_with @user.tap(&:destroy), location: index_path
  end

  private

  def index_path
    internal_users_path
  end

  def find
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email,:password,:password_confirmation, :first_name, :last_name)
  end
end
