require 'test_helper'

class ImportControllerTest < ActionController::TestCase
  setup do
    sign_in users(:john)
  end

  test 'create' do
    Factory(:organization, name: 'LUNARIA', code: 'LUNAR')
    file = Rack::Test::UploadedFile.new('test/fixtures/xml/PEF_lunar31_20141112.xml')

    post :create, { pef: file }
    assert_response :success

    wc = json_response['workcamps'].first
    assert_equal 'imported',wc['state']
    assert_equal 'AGAPE 06',wc['name']
    assert_equal 'LUNAR 31',wc['code']
    # assert_equal 'f9c91026d627166ce372501d4c55f690',wc['project_id']
  end

end
