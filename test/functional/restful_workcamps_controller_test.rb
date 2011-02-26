require 'test_helper'
require 'test/functional/restful_controller_test'

class RestfulWorkcampsControllerTest < RestfulControllerTest

  # setup do
  #   Factory.create(:outgoing_workcamp, :country => Factory.create(:czech_republic))
  # end

  # test "workcamp retrieval with country and intention" do
  #   get :index, :format => 'xml'

  #     puts @response.body

  #   assert_select "workcamps > workcamp > country > code" do |elements|
  #     assert_valid_code Country, elements
  #   end

  #   assert_select "workcamps > workcamp > intentions > intention > code" do |elements|
  #     assert_valid_code WorkcampIntention, elements
  #   end
  # end

  # test "total count" do
  #   get :total, :format => 'xml'
  #   assert_select 'total'
  # end

  # protected


  # def extract_text(element)
  #   element.children.first.to_s
  # end

  # def assert_valid_code(model, elements)
  #   elements.each do |e|
  #     assert model === model.find_by_code(extract_text(e))
  #   end
  # end

end
