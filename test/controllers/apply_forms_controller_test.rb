require 'test_helper'

class ApplyFormsControllerTest < ActionController::TestCase
  setup do
    @apply_form = Factory(:apply_form)
    sign_in create(:user)
  end

  test 'index' do
    wc = Factory(:outgoing_workcamp, name: 'My favorite camp')
    @apply_form.assign_workcamp(wc)

    get :index
    assert_response :success

    assert_equal 1, json_response['apply_forms'].size
    assert_equal wc.id, json_response['apply_forms'].first['current_workcamp_id']
  end

  test "index.csv" do
    get :index, format: :csv
    assert_response :success
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

    get :index, state: 'alerts'
    assert_response :success    

    # regression test
    get :index, state: ''
    assert_response :success
  end

  test 'index ordering' do
    get :index, order: 'createdAt', asc: 'false'
    assert_response :success

    get :index, order: 'name', asc: 'false'
    assert_response :success

    get :index, order: 'from', asc: 'false'
    assert_response :success

    get :index, order: 'from', asc: 'false'
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

  test 'filter pending' do
    ApplyForm.destroy_all
    paid = Factory(:paid_form)
    decoy = Factory(:apply_form)
    decoy.payment.destroy

    get :index, state: 'pending'

    assert_response :success
    assert_equal 1,json[:apply_forms].size
    assert_equal paid.id, json[:apply_forms][0][:id].to_i
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
    Factory(:apply_form, firstname: 'Our', lastname: 'Target')
    3.times { Factory(:apply_form, firstname: 'Someone', lastname: 'Else') }

    get :index
    assert_response :success
    assert_equal 4,json_response['apply_forms'].size

    get :index, q: 'target'
    assert_response :success
    assert_equal 1,json_response['apply_forms'].size
  end

  test 'filter by volunteer' do
    target = Factory(:apply_form, firstname: 'Our', lastname: 'Target')
    dummy = Factory(:apply_form)

    get :index, volunteer_id: target.volunteer_id

    assert_response :success
    assert_equal 1, json[:apply_forms].size
    assert_equal target.id, json[:apply_forms][0][:id]
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

  test 'create' do
    assert_difference 'ApplyForm.count',1 do
      post :create, apply_form: Factory.attributes_for(:paid_form)
      assert_response :success,response.body
    end
  end

  test 'create with workcamps' do
    assert_difference 'Outgoing::WorkcampAssignment.count',1 do
      assert_difference 'ApplyForm.count',1 do
        wc = Factory(:outgoing_workcamp)
        post :create, apply_form: Factory.attributes_for(:paid_form).merge(workcamp_ids: [wc.id])
        assert_response :success,response.body
      end
    end
  end

  test 'create incoming' do
    assert_difference 'Outgoing::WorkcampAssignment.count',1 do
      assert_difference 'Incoming::ApplyForm.count',1 do
        wc = Factory(:incoming_workcamp)
        attrs = Factory.attributes_for(:incoming_apply_form).merge({
          workcamp_ids: [wc.id],
          type: 'incoming',
          country_id: Factory(:country).id,
          organization_id: Factory(:organization).id
        })

        post :create, apply_form: attrs

        assert_response :success,response.body
        assert_not_nil form = Incoming::ApplyForm.find(json[:apply_forms].first[:id])
        assert_equal :accepted, form.state.name
      end
    end
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
