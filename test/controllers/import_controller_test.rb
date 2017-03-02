require 'test_helper'

class ImportControllerTest < ActionController::TestCase
  setup do
    Factory(:organization, name: 'LUNARIA', code: 'LUNAR')
    sign_in users(:john)
    path = "#{Rails.root}/test/fixtures/pef/PEF_lunar31_20141112.xml"
    @file = Rack::Test::UploadedFile.new(path,'text/xml')
  end

  teardown do
    @file.close
  end


  # Failing on CI because of the file upload :/
  #
  # test 'create' do
  #   assert_difference 'Outgoing::Workcamp.count' do
  #     post :create, { pef: @file }
  #     assert_response :success
  #     assert_equal json_response, {"import_messages"=>[{"level"=>"success", "text"=>"Workcamp AGAPE 06(LUNAR 31) prepared for creation."}]}
  #   end
  # end

  # test 'create LTV' do
  #   assert_difference 'Ltv::Workcamp.count' do
  #     post :create, { pef: @file, type: 'ltv' }
  #     assert_response :success
  #     assert_equal json_response, {"import_messages"=>[{"level"=>"success", "text"=>"Workcamp AGAPE 06(LUNAR 31) prepared for creation."}]}
  #   end
  # end

  test 'confirm_all' do
    Workcamp.destroy_all
    2.times { create_imported_wc }

    assert_equal 2,Workcamp.imported_or_updated.count
    assert_equal 0,Workcamp.live.count

    put :confirm_all

    assert_equal 0,Workcamp.imported_or_updated.count
    assert_equal 2,Workcamp.live.count
  end

  test 'cancel_all' do
    Workcamp.destroy_all
    2.times { create_imported_wc }

    assert_equal 2,Workcamp.imported_or_updated.count
    assert_equal 0,Workcamp.live.count

    delete :cancel_all

    assert_equal 0,Workcamp.imported_or_updated.count
    assert_equal 0,Workcamp.live.count

  end

  private

  def create_imported_wc
    wc = Factory(:workcamp,state: 'imported')
    Factory(:import_change, workcamp: wc)
    wc
  end

end
