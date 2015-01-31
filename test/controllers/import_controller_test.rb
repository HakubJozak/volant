require 'test_helper'

class ImportControllerTest < ActionController::TestCase
  setup do
    sign_in users(:john)
  end

  test 'create' do
    Factory(:organization, name: 'LUNARIA', code: 'LUNAR')
    post :create, { pef: fixture_file_upload('xml/PEF_lunar31_20141112.xml') }
    assert_response :success
    assert_equal json_response, {"import_messages"=>[{"level"=>"success", "text"=>"Workcamp AGAPE 06(LUNAR 31) prepared for creation."}]}
    # wc = json_response['workcamps'].first
    # assert_equal 'imported',wc['state']
    # assert_equal 'AGAPE 06',wc['name']
    # assert_equal 'LUNAR 31',wc['code']
    # assert_equal 'f9c91026d627166ce372501d4c55f690',wc['project_id']
  end

end
