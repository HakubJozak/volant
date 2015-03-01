require 'test_helper'

class WorkcampsControllerTest < ActionController::TestCase
  setup do
    Workcamp.destroy_all
    @workcamp = Factory(:workcamp)
    sign_in @john = users(:john)
  end

  test "index" do
    get :index, p: 1
    assert_response :success
    assert_equal Workcamp.count, json_response['meta']['pagination']['total']
  end

  test 'index for incoming' do
    Workcamp.destroy_all
    target = Factory(:incoming_workcamp, organization: organizations(:inex))
    dummy = Factory(:outgoing_workcamp)

    get :index, type: 'incoming'

    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test 'index for LTV' do
    Workcamp.destroy_all
    target = Factory(:ltv_workcamp, organization: organizations(:inex))
    dummy = Factory(:workcamp)

    get :index, type: 'ltv'

    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test "search by code" do
    3.times { Factory(:workcamp) }

    @workcamp.update_attribute(:code,'WRC-1')
    get :index, q: 'WRC'
    assert_response :success
    assert_equal 1, json_response['workcamps'].size
    assert_equal @workcamp.id, json_response['workcamps'][0]['id']

    get :index, q: 'STRING NOT THERE'
    assert_equal 0, json_response['workcamps'].size
  end

  test "search by name" do
    3.times { Factory(:workcamp) }
    @workcamp.update_attribute(:name,'Great project in Alaska')

    get :index
    assert_equal 4, json_response['workcamps'].size

    get :index, q: 'great'
    assert_equal 1, json_response['workcamps'].size
    assert_equal @workcamp.id, json_response['workcamps'][0]['id']

    get :index, q: 'STRING NOT THERE'
    assert_equal 0, json_response['workcamps'].size
  end

  test "filter by year" do
    Workcamp.destroy_all
    4.times { |i| Factory(:workcamp, :'begin' => Date.new(2010+i,2), :'end' => Date.new(2010+i,3)) }

    get :index, year: 2013
    assert_response :success
    assert_equal 1, json_response['workcamps'].size

    get :index, year: 'garbage'
    assert_response :success
    assert_equal 4, json_response['workcamps'].size
  end

  test 'filter by from' do
    Workcamp.destroy_all
    target = Factory(:workcamp, begin: '2012-03-22')
    dummy = Factory(:workcamp, begin: '2012-01-22')

    get :index, from: '2012-02-23'
    assert_response :success

    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test 'filter by to' do
    Workcamp.destroy_all
    dummy = Factory(:workcamp, end: '2012-03-22')
    target = Factory(:workcamp, end: '2012-01-22')

    get :index, to: '2012-02-23'
    assert_response :success

    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test 'min_duration' do
    Workcamp.destroy_all
    target = Factory(:workcamp, begin: '2012-02-22', end: '2012-03-22')
    dummy = Factory(:workcamp, begin: '2012-03-22', end: '2012-03-25')

    get :index, min_duration: 15
    assert_response :success

    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test 'max_duration' do
    Workcamp.destroy_all
    dummy = Factory(:workcamp, begin: '2012-02-22', end: '2012-03-22')
    target = Factory(:workcamp, begin: '2012-03-22', end: '2012-03-25')

    get :index, max_duration: 4
    assert_response :success

    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test 'age' do
    Workcamp.destroy_all
    target = Factory(:workcamp, minimal_age: 40, maximal_age: 60)
    dummy = Factory(:workcamp, minimal_age: 15, maximal_age: 30)

    get :index, age: 55

    assert_response :success
    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test 'free' do
    Workcamp.destroy_all
    target = Factory(:workcamp, places: 2, places_for_males: 1, places_for_females: 1)
    get :index, free_places: 1
    assert_response :success
    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test 'filter by starred' do
    Workcamp.destroy_all
    target = Factory(:workcamp)
    target.add_star(@john)
    dummy = Factory(:workcamp)

    get :index, starred: true

    assert_response :success
    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test "should show workcamp" do
    get :show, id: @workcamp
    assert_response :success
  end

  test "create" do
    assert_difference('Outgoing::Workcamp.count') do
      inex = organizations(:inex)
      attrs = Factory.attributes_for(:workcamp, country_id: inex.country.id, organization_id: inex.id)
      post :create, workcamp: attrs

      assert_response :success, response.body.to_s
      assert_not_nil json_response['workcamp']['id'], json_response
    end
  end

  test "create incoming" do
    assert_difference('Incoming::Workcamp.count') do
      inex = organizations(:inex)
      attrs = Factory.attributes_for(:incoming_workcamp, country_id: inex.country.id, organization_id: inex.id, type: 'incoming')

      post :create, workcamp: attrs

      assert_response :success, response.body.to_s
      assert_not_nil json_response['workcamp']['id'], json_response
      assert_equal 'incoming',json_response['workcamp']['type']
    end
  end


  test "should update workcamp" do
    id = ColoredTag.find_by_name('family').id

    patch :update, id: @workcamp, workcamp: { name: 'edited', code: 'new-code', :'end' =>  "2014-06-26", tag_ids: [id]}
    assert_response :success

    assert_equal Date.new(2014,6,26), @workcamp.reload.end
    assert_equal ['family'], @workcamp.reload.tag_list
    assert_equal 'edited', json_response['workcamp']['name']
    assert_equal 'new-code', json_response['workcamp']['code']
  end

  test "should destroy workcamp" do
    assert_difference('Workcamp.count', -1) do
      delete :destroy, id: @workcamp
    end

    assert_response :no_content
  end

  test 'cancel_import' do
    @workcamp.name = 'Old name'
    @workcamp.state = 'updated'
    @workcamp.import_changes.create!(field: 'name', value:'Brand new name')
    @workcamp.save!

    post :cancel_import, id: @workcamp.id

    @workcamp.reload
    assert_equal 0,@workcamp.import_changes.count
    assert_equal 'Old name',@workcamp.name
    assert_equal nil, @workcamp.state
  end

  test 'confirm_import' do
    @workcamp.state = 'updated'
    @workcamp.import_changes.create!(field: 'name', value:'Brand new name')
    @workcamp.save!

    post :confirm_import, id: @workcamp.id

    @workcamp.reload
    assert_equal 0,@workcamp.import_changes.count
    assert_equal 'Brand new name',@workcamp.name
    assert_equal nil, @workcamp.state
  end

end
