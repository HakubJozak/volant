class RestfulController < ApplicationController
  # TODO - handle rights!
  skip_before_filter :login_required
  before_filter :http_authenticate

  # TODO - demand HTTPS
  def http_authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      User.authenticate(user_name, password)
    end
  end

end
