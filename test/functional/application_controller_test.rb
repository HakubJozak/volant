require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  test "authentication" do
    get :index
    login = { :controller => :session, :action => :new }
    assert_redirected_to login
  end

  test "auto-complete routing" do
    assert_routing '/outgoing/apply_forms/auto_complete_belongs_to_for_record_volunteer_name', 
                   :controller => 'outgoing/apply_forms', :action => 'auto_complete_belongs_to_for_record_volunteer_name'
  end


end
