require 'test_helper'

class StarsControllerTest < ActionController::TestCase

  setup do
    @john = users(:john)
    sign_in @john
  end

  test 'create star for workcamp' do
    wc = Factory(:workcamp)
    post :create, star: { id: wc.id, model: 'workcamp', value: true }
    assert_response :success
    assert wc.reload.starred, 'workcamp is not starred'
  end

  test 'create star for apply form' do
    wc = Factory(:apply_form)
    post :create, star: { id: wc.id, model: 'apply_form', value: true }
    assert_response :success
    assert wc.reload.starred, 'apply_form is not starred'
  end

  # test 'create star for volunteer' do
  #   wc = Factory(:volunteer)
  #   post :create, star: { id: wc.id, model: 'volunteer', value: true }
  #   assert_response :success
  #   assert wc.reload.starred, 'volunteer is not starred'
  # end


end
