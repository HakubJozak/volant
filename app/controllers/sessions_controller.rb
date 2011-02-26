# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController

  skip_before_filter :login_required
  layout 'login'

  def index
    redirect_to :action => 'new'
  end

  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token ,
                                 :expires => self.current_user.remember_token_expires_at }
      end

      flash[:notice] = "Logged in successfully"
      redirect_to outgoing_apply_forms_path
    else
      flash[:notice] = "Failed to log in"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(root_path)
  end
end
