require 'test_helper'

class StarsControllerTest < ActionController::TestCase

  setup do
    @john = users(:john)
    sign_in @john
  end

  test 'create star for workcamp' do
    wc = Factory(:outgoing_workcamp)
    post :create, star: { id: wc.id, model: 'workcamp', value: 'true' }
    assert_response :success
    assert User.find(@john.id).has_starred?(wc), 'workcamp is not starred'
  end

  test 'create star for apply form' do
    form = Factory(:apply_form)
    post :create, star: { id: form.id, model: 'apply_form', value: 'true' }
    assert_response :success
    assert User.find(@john.id).has_starred?(form), 'apply_form is not starred'
  end

  # test 'create star for volunteer' do
  #   wc = Factory(:volunteer)
  #   post :create, star: { id: wc.id, model: 'volunteer', value: true }
  #   assert_response :success
  #   assert wc.reload.starred, 'volunteer is not starred'
  # end


end
