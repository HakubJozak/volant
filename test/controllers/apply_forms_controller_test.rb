require 'test_helper'

class ApplyFormsControllerTest < ActionController::TestCase
  setup do
    @apply_form = Factory(:apply_form)
    sign_in users(:john)
  end



  # test 'sorting' do
  #   ApplyForm.destroy_all

  #   volunteers = (1..5).to_a.map { |i|
  #     f = Factory(:apply_form)
  #     f.volunteer.firstname = 'John'
  #     f.volunteer.lastname = i.to_s
  #     f.volunteer.save!
  #     f.volunteer
  #   }

  #   get :index, sort: 'name', asc: true
  #   assert_response :success

  #   assert_equal volunteers[0].id, json_response['apply_forms'].first['volunteer_id']
  #   assert_equal volunteers[4].id, json_response['apply_forms'].last['volunteer_id']
  # end


  test 'index' do
    wc = Factory(:outgoing_workcamp, name: 'My favorite camp')
    @apply_form.assign_workcamp(wc)

    get :index
    assert_response :success

    assert_equal 1, json_response['apply_forms'].size
    assert_equal wc.id, json_response['apply_forms'].first['current_workcamp_id']
  end


  # regression test for http://redmine.siven.onesim.net/issues/1430
  test 'index with assigned incoming workcamp' do
    wc = Factory(:incoming_workcamp, name: 'My favorite camp')
    @apply_form.assign_workcamp(wc)
    @apply_form.save!

    get :index
    assert_response :success

    assert_equal 1, json_response['apply_forms'].size
    assert_equal wc.id, json_response['apply_forms'].first['current_workcamp_id']
  end
  
  test 'show' do
    get :show, id: @apply_form.id
    assert_response :success
    assert_equal 1, json_response['apply_forms'].size
  end

  test 'vef.html' do
    get :vef, id: @apply_form.id, format: :html
    assert_response :success
  end

  test 'vef.xml' do
    get :vef, id: @apply_form.id, format: :xml
    assert_response :success
  end

  test 'special states' do
    get :index, state: 'leaves'
    assert_response :success

    get :index, state: 'returns'
    assert_response :success

    get :index, state: 'just_submitted'
    assert_response :success
    
    get :index, state: 'on_project'
    assert_response :success

    # regression test
    get :index, state: ''
    assert_response :success    
  end
  
  test 'filter by state' do
    ApplyForm.destroy_all
    dummy = Factory(:paid_form)
    accepted = Factory(:accepted_form)

    get :index, state: 'accepted'

    assert_response :success
    assert_equal 1,json_response['apply_forms'].size
    assert_equal accepted.id, json_response['apply_forms'][0]['id'].to_i
  end

  test 'filter infosheeted' do
    ApplyForm.destroy_all
    dummy = Factory(:accepted_form)
    infosheeted = Factory(:accepted_form)
    infosheeted.current_assignment.update_column :infosheeted, Date.today
    
    get :index, state: 'infosheeted'

    assert_response :success
    assert_equal 1,json_response['apply_forms'].size
    assert_equal infosheeted.id, json_response['apply_forms'][0]['id'].to_i
  end

  test 'filter unpaid' do
    ApplyForm.destroy_all
    dummy = Factory(:paid_form)
    unpaid = Factory(:apply_form)
    unpaid.payment.destroy

    get :index, state: 'without_payment'

    assert_response :success
    assert_equal 1,json_response['apply_forms'].size
    assert_equal unpaid.id, json_response['apply_forms'][0]['id'].to_i
  end

  test 'index with query' do
    ApplyForm.destroy_all
    volunteer = Factory(:volunteer, firstname: 'John', lastname: 'Deer')
    Factory(:apply_form, volunteer: volunteer)
    3.times { Factory(:apply_form) }

    get :index
    assert_response :success
    assert_equal 4,json_response['apply_forms'].size

    get :index, q: 'john'
    assert_response :success
    assert_equal 1,json_response['apply_forms'].size
  end


  test "update" do
    payment = Factory.attributes_for(:payment, amount: 1111)

    patch :update, id: @apply_form.id, apply_form: { motivation: 'endless', general_remarks: 'none', payment_attributes: payment }

    assert_response :success
    assert_equal 'none', json_response['apply_form']['general_remarks']
    assert_equal 'endless', json_response['apply_form']['motivation']
    assert_equal 1111, @apply_form.reload.payment.amount
  end

  test "update - remove all tags" do
    @apply_form.tags << ColoredTag.find_by_name('family')
    @apply_form.save!

    put :update, id: @apply_form.id, apply_form: { tag_ids: nil }
    assert_response :success

    assert_equal [],@apply_form.tags.reload
  end
  

  test 'cancel' do
    post :cancel, id: @apply_form.id
    assert_equal :cancelled,@apply_form.reload.state.name
  end

  test 'ask' do
    wc = Factory(:outgoing_workcamp)
    form = Factory(:paid_form)
    form.assign_workcamp(wc)

    post :ask, id: form.id

    assert_response :success
    assert_equal :asked,form.reload.state.name
  end

end
