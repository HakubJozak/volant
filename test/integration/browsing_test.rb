require 'test_helper'

class BrowsingTest < ActionController::IntegrationTest
  fixtures :all

  test "login redirects to root url" do
    jana = regular_user
    jana.logs_in
  end

  def regular_user
    open_session do |user|
      def user.logs_in
        get_via_redirect '/sessions'
        assert_template 'sessions/new'

        post '/sessions/create', :login => 'admin', :password => 'test'
        assert_response :redirect
      end
    end
  end
end
