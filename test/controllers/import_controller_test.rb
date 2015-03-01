require 'test_helper'

class ImportControllerTest < ActionController::TestCase
  setup do
    Factory(:organization, name: 'LUNARIA', code: 'LUNAR')
    sign_in users(:john)
  end

  test 'create' do
    assert_difference 'Outgoing::Workcamp.count' do
      post :create, { pef: fixture_file_upload('xml/PEF_lunar31_20141112.xml') }
      assert_response :success
      assert_equal json_response, {"import_messages"=>[{"level"=>"success", "text"=>"Workcamp AGAPE 06(LUNAR 31) prepared for creation."}]}
    end
  end

  test 'create LTV' do
    assert_difference 'Ltv::Workcamp.count' do
      post :create, { pef: fixture_file_upload('xml/PEF_lunar31_20141112.xml'), type: 'ltv' }
      assert_response :success
      assert_equal json_response, {"import_messages"=>[{"level"=>"success", "text"=>"Workcamp AGAPE 06(LUNAR 31) prepared for creation."}]}      
    end
  end

end
