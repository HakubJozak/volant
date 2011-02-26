require 'test_helper'

class EmailTemplatesControllerTest < ActionController::TestCase

  include ActiveScaffoldReadOnlyTester

  test "templates howto display" do
    get :howto
    assert_response :success
  end

  test "howto routing" do
    assert_routing '/email_templates/howto', :controller => 'email_templates', :action => 'howto'
  end


  protected

  def item
    Factory.create(:email_template)
  end
end
