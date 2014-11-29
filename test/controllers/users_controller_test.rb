class UsersControllerTest < ActionController::TestCase

  setup do
    @john = users(:john)
    sign_in @john
  end

  test 'index' do
    get :index
    assert_response :success
    assert_equal User.count,json_response['users'].size
  end

  test 'update' do
    patch :update, id: @john.id, user: { email: 'my-other-email@there.com' }
    assert_response :success
    assert_equal 'my-other-email@there.com',@john.reload.email
  end

  test 'destroy' do
    delete :destroy, id: @john.id
    assert_response :success
    refute User.find_by_id(@john.id)
  end

  test 'create' do
    post :create, user: { email: 'new-email@here.com', password: 'mypass123' }
    assert_response :success
    assert_equal 2,User.count
  end

  test 'create without password' do
    post :create, user: { email: 'new-email@here.com' }
    assert_response :unprocessable_entity
    assert_not_empty json_response['errors']['password'].first
  end


end
