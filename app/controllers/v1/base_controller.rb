class V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :check_access_token!

  def check_access_token!
    if Rails.application.config.api_access_tokens.include?(params[:access_token])
      true
    else
      render json: { error: 'Invalid authentication token' }, status: 401
      false
    end
  end
end
