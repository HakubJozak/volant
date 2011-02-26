require 'test_helper'
require 'test/functional/restful_controller_test'

class RestfulWorkcampIntentionsControllerTest < RestfulControllerTest

  test "retrieve ENVI intention" do
    get :index, :code => 'ENVI', :format => 'xml'
    assert_select 'workcamp-intentions > workcamp-intention > code', 'ENVI'
  end

  test "REST routing of workcamp intentions" do
    params = { :controller => 'RestfulWorkcampIntentions', :action => 'index', :format => 'xml' }
    assert_recognizes params, '/rest/workcamp_intentions.xml'
  end
end
