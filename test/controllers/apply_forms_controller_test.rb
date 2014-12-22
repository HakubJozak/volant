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

  test 'filter by state' do
    ApplyForm.destroy_all
    dummy = Factory(:paid_form)
    accepted = Factory(:accepted_form)

    get :index, state: 'accepted'

    assert_response :success
    assert_equal 1,json_response['apply_forms'].size
    assert_equal accepted.id, json_response['apply_forms'][0]['id'].to_i
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

  test 'cancel' do
    post :cancel, id: @apply_form.id
    assert_equal :cancelled,@apply_form.reload.state.name
  end


end
