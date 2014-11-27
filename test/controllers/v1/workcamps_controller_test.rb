require 'test_helper'

class V1::WorkcampsControllerTest < ActionController::TestCase
  setup do
    Outgoing::Workcamp.destroy_all

    dummy = Factory(:outgoing_workcamp)
    @workcamp = Factory(:outgoing_workcamp)
    @family = ColoredTag.find_by_name('family')
    @teenage = ColoredTag.find_by_name('teenage')
  end

  test "search by tags" do
    @workcamp.tag_list << 'family'
    @workcamp.tag_list << 'teenage'
    @workcamp.save!

    get :index, tag_ids: [ @family.id, @teenage.id ]

    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end

  test "search by intentions" do
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

  test "search by countries" do
    @workcamp.country = c = Factory(:country)
    @workcamp.save!

    get :index, country_ids: [ c.id ]

    assert_response :success
    assert_equal 1, json_response['meta']['pagination']['total']
    assert_equal @workcamp.id, json_response['workcamps'].first['id'].to_i
  end


end
