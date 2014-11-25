require 'test_helper'

class WorkcampsControllerTest < ActionController::TestCase
  setup do
    Workcamp.destroy_all
    @workcamp = Factory(:workcamp)
    sign_in users(:john)
  end

  test "should get index" do
    get :index, p: 1
    assert_response :success
    assert_equal Workcamp.count, json_response['meta']['pagination']['total']
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
    assert target.duration >= 15
  end

  test 'max_duration' do
    Workcamp.destroy_all
    dummy = Factory(:workcamp, begin: '2012-02-22', end: '2012-03-22')
    target = Factory(:workcamp, begin: '2012-03-22', end: '2012-03-25')

    get :index, max_duration: 4
    assert_response :success

    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
    assert target.duration <= 4
  end

  test 'age' do
    Workcamp.destroy_all
    target = Factory(:workcamp, minimal_age: 15, maximal_age: 30)
    dummy = Factory(:workcamp, minimal_age: 11, maximal_age: 40)

    get :index, min_age: 14, maximal_age: 35

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
    target = Factory(:workcamp, starred: true)
    dummy = Factory(:workcamp, starred: false)
    get :index, starred: true
    assert_response :success
    assert_equal 1, json_response['workcamps'].size
    assert_equal target.id, json_response['workcamps'].first['id']
  end

  test "should show workcamp" do
    get :show, id: @workcamp
    assert_response :success
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

    assert_redirected_to workcamps_path
  end

end
