require 'test_helper'
require 'test/functional/restful_controller_test'

class RestfulCountriesControllerTest < RestfulControllerTest

  test "retrieve all countries" do
    get :index, :format => 'xml'
    assert_response :success
    assert_select "countries > country", Country.count
  end

  test "retrieve one country" do
    get :show, :format => 'xml', :id => Country.find(:first).id
    assert_response :success
  end

  test "retrieve Austria by code" do
    get :index, :format => 'xml', :code => 'AT'
    assert_select 'country > code', 'AT'
  end

  test "retrieve non-existent code" do
    #get :index, :format => 'xml', :code => 'UNKNOWN'
    # TODO - respond by 404
  end

  test "REST countries routing" do
    params = { :controller => 'RestfulCountries', :action => 'index', :format => 'xml' }
    assert_recognizes params, '/rest/countries.xml'
  end

end
