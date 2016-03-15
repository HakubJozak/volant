require 'test_helper'

class V1::WorkcampsControllerTest < ActionController::TestCase
  setup do
    Outgoing::Workcamp.destroy_all

    @workcamp = Factory(:outgoing_workcamp)
    @family = ColoredTag.find_by_name('family')
    @teenage = ColoredTag.find_by_name('teenage')
  end

  test "search by tags" do
    dummy = Factory(:outgoing_workcamp)
    @workcamp.tag_list << 'family'
    @workcamp.tag_list << 'teenage'
    @workcamp.save!

    get :index, tag_ids: [ @family.id, @teenage.id ]

    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']

    wc = json_response['workcamps'].first
    assert_equal @workcamp.id, wc['id'].to_i
    assert_equal ['family','teenage'], wc['tags'].map {|t| t['name'] }
  end

  test 'search LTV' do
    target = Factory(:ltv_workcamp)
    get :index, type: 'ltv'
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal target.id, json_response['workcamps'][0]['id']
  end

  test "search by intentions" do
    decoy = create :outgoing_workcamp
    target = create :outgoing_workcamp
    agri = workcamp_intentions(:agri)
    animal = workcamp_intentions(:animal)

    target.intentions << agri
    target.save!
    
    @workcamp.intentions << agri
    @workcamp.intentions << animal
    @workcamp.save!

    get :index, workcamp_intention_ids: [ agri.id, animal.id ]

    assert_response :success
    assert_equal 2, json_response['meta']['pagination']['total']
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

  test "search by country zones" do
    dummy = Factory(:outgoing_workcamp)
    @workcamp.country = c = Factory(:country)
    @workcamp.save!

    get :index, country_zone_id: @workcamp.country.country_zone.id

    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

  test "search by countries" do
    dummy = Factory(:outgoing_workcamp)
    @workcamp.country = c = Factory(:country)
    @workcamp.save!

    get :index, country_ids: [ c.id ]

    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

  test 'search by people' do
    @workcamp.update_columns(free_places_for_females: 1,
                             free_places_for_males: 1,
                             free_places: 2,
                             minimal_age: 90,
                             maximal_age: 100)

    get :index, people: { '0' => { a: 22, g: 'm'}, '1' => { a: 33, g: 'f'} }
    assert_response :success
    assert_equal 0, json_response['meta']['pagination']['total']

    get :index, people: { '0' => { a: 95, g: 'm'}, '1' => { a: 100, g: 'f'} }
    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

  test 'search by gender' do
    @workcamp.update_columns(free_places_for_females: 0,
                             free_places_for_males: 1,
                             free_places: 1)
    get :index, people: { '0' => { g: 'm'} }
    assert_response :success
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

  test 'search by age' do
    @workcamp.update_columns(minimal_age: 90,
                             maximal_age: 100)
    get :index, people: { '0' =>  { a: 93} }
    assert_response :success
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

  test 'search by scope' do
    get :index, scope: 'new', country_zone_id: @workcamp.country.country_zone.id
    assert_response :success

    get :index, scope: 'urgent'
    assert_response :success
  end

  test "short" do
    Workcamp.delete_all

    # dummy
    create(:outgoing_workcamp, begin: 2.weeks.ago, end: 1.week.ago)
    5.times { |i| create(:outgoing_workcamp, begin: i.weeks.from_now) }

    get :short

    assert_response :success
    assert_nil json_response['meta'], 'there should be no pagination present'
    assert_equal 5,json_response['workcamps'].size
  end

  # TODO: cover LTV case
  test 'similar' do
    # to be ignored:
    dummy = create(:outgoing_workcamp, country: countries(:IT))
    too_old = create(:outgoing_workcamp, begin: 1.year.ago, end: 11.months.ago)
    # TODO - hardwire season
    next_season = create(:outgoing_workcamp, publish_mode: 'SEASON')
    full = create(:outgoing_workcamp, places: 0)
    # to be found:
    target = create(:outgoing_workcamp)

    @workcamp.intentions.each { |i|
      full.intentions << i
      wc.intentions << i
    }

    get :similar, id: @workcamp.id

    assert_response :success
    assert_equal 1,json[:workcamps].size
    assert_equal target.id,json[:workcamps][0][:id]
  end

  test 'search by duration' do
    Workcamp.destroy_all
    target = create :workcamp, duration: 10
    decoy = create :workcamp, duration: 4

    get :index, duration: '8-15'
    assert_equal 1,json[:workcamps].size
    assert_equal target.id,json[:workcamps][0][:id]

    # wrong input is ignored
    get :index, duration: 'XXX'    
    assert_equal 2,json[:workcamps].size
  end
  
  test 'search by from' do
    Workcamp.destroy_all
    target = Factory(:outgoing_workcamp, begin: 30.days.from_now)
    get :index, from: 15.days.from_now.to_s
    assert_response :success
    assert_equal target.id,json_response['workcamps'][0]['id']

    # regression to parse_errors
    get :index, from: 'cerven'
    assert_response :success
  end


  test 'search by to' do
    # regression to parse_errors
    get :index, to: 'cerven'
    assert_response :success
  end



end
