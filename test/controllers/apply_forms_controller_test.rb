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

  test 'index with query' do
    ApplyForm.destroy_all
    volunteer = Factory(:volunteer, firstname: 'John', lastname: 'Deer')
    Factory(:apply_form, volunteer: volunteer)
    3.times { Factory(:apply_form) }

    get :index
    assert_response :success
    assert_equal 4,json_response['apply_forms'].size

    get :index, query: 'john'
    assert_response :success
    assert_equal 1,json_response['apply_forms'].size
  end


  test "update" do
    patch :update, id: @apply_form.id, apply_form: { motivation: 'endless', general_remarks: 'none' }
    assert_response :success
    assert_equal 'none', json_response['apply_form']['general_remarks']
    assert_equal 'endless', json_response['apply_form']['motivation']
  end

end
