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
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

  test "search by intentions" do
    dummy = Factory(:outgoing_workcamp)
    agri = workcamp_intentions(:agri)
    animal = workcamp_intentions(:animal)

    @workcamp.intentions << agri
    @workcamp.intentions << animal
    @workcamp.save!

    get :index, workcamp_intention_ids: [ agri.id, animal.id ]

    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
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

    get :index, people: [ { a: 22, g: 'm'},{ a: 33, g: 'f'} ]
    assert_response :success
    assert_equal 0, json_response['meta']['pagination']['total']

    get :index, people: [ { a: 95, g: 'm'},{ a: 100, g: 'f'} ]
    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

end
