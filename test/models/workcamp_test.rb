require 'test_helper'


class WorkcampTest < ActiveSupport::TestCase

  fixtures :all

  setup do
    @wc = Factory.create(:workcamp, :begin => 1.day.from_now, :end => 10.days.from_now)
    @family = ColoredTag.find_by_name('family')
    @teenage = ColoredTag.find_by_name('teenage')
  end

  test 'tag_ids=' do
    ids = [ @family.id, @teenage.id ]
    @wc.tag_ids = ids
    @wc.save!
    assert_equal ['family','teenage'], @wc.tag_list
  end

  test 'scope with_tags' do
    @wc.tag_list << 'family'
    @wc.save!

    result = Workcamp.with_tags(@family.id)

    assert result.map(&:id).include?(@wc.id)
    assert_empty Workcamp.with_tags(777777)
  end

  test 'scope with_workcamp_intentions' do
    @wc.intentions << (agri = workcamp_intentions(:agri))
    @wc.intentions << (refugee = workcamp_intentions(:refugee))

    result = Workcamp.with_workcamp_intentions(agri.id,refugee.id)

    assert result.map(&:id).include?(@wc.id)
  end

  test 'similar_to scope' do
    target = Factory(:workcamp)
    dummy = Factory(:workcamp, country: countries(:AT))
    @wc.intentions << (agri = workcamp_intentions(:agri))
    @wc.intentions << (refugee = workcamp_intentions(:refugee))
    target.intentions << agri << refugee

    result = Workcamp.similar_to(@wc)
    ids = result.map(&:id)

    assert_equal ids.first, target.id
    refute ids.include?(@wc.id), 'Original WC should not be included as similar'
    refute ids.include?(dummy.id), 'Different countries should be excluded'
  end

  test 'scope with_countries' do
    country = @wc.country
    result = Workcamp.with_countries(country.id,777777)
    assert result.map(&:id).include?(@wc.id)
  end

  test 'scope with_organizations' do
    org = @wc.organization
    result = Workcamp.with_organizations(org.id,777777)
    assert result.map(&:id).include?(@wc.id)
  end

  test "validate based on schema rules" do
    wc = workcamps(:kytlice)
    assert_validates_presence_of wc, :name, :code, :places, :country
  end

  test "workcamps with intentions deletion" do
    wc = workcamps(:xaverov)
    agri = workcamp_intentions(:agri)
    assert wc.intentions.include?(agri)

    assert_nothing_raised do
      wc.destroy
      WorkcampIntention.find(agri.id)
    end
  end

  test 'have scope by year' do
    wc = Factory(:outgoing_workcamp,
                 :begin => Date.new(1848,1,1),
                 :end => Date.new(1848,2,2))
    assert_equal wc, Workcamp.year(1848).first
  end

  test "add intentions" do
    wc = Factory(:outgoing_workcamp)
    wc.intentions << WorkcampIntention.first
    assert_nothing_raised {  wc.save! }
  end

  test "csv export" do
    skip 'CSV export not implemented for workcamps'
    assert_not_nil Workcamp.first.to_csv
  end

  # regression bug (validation of intentions while saving workcamps)
  test "create with intentions" do
    inex = organizations(:inex)
    attrs = Factory.attributes_for(:workcamp, country_id: inex.country.id, organization_id: inex.id)
    attrs[:workcamp_intention_ids] = [ workcamp_intentions(:animal).id ]

    wc = Workcamp.new(attrs)

    assert wc.save, wc.errors.full_messages
  end

  test 'query' do
    Workcamp.destroy_all
    target = Factory.create(:workcamp,code: 'MYCODE')
    dummy = Factory.create(:workcamp,code: 'XXX')

    result = Workcamp.joins(:organization).query('  MYCODE  ')

    assert_equal 1,result.size
    assert_equal target.id,result.first.id
  end

  test '#price' do
    # incoming workcamp is for 1000
    wc = Factory.create(:incoming_workcamp, country: countries(:CZ))
    assert_equal 1000, wc.price

    # region 2 default
    wc = Factory.create(:outgoing_workcamp, country: countries(:AF))
    assert_equal 2500, wc.price

    # region 1 default
    wc = Factory.create(:outgoing_workcamp, country: countries(:AT))
    assert_equal 2200, wc.price
    
    # overrided by DB
    wc = Factory.create(:outgoing_workcamp, country: countries(:AF), price: 400)
    assert_equal 400, wc.price
  end

end

# == Schema Information
#
# Table name: workcamps
#
#  id                       :integer          not null, primary key
#  code                     :string(255)      not null
#  name                     :string(255)      not null
#  country_id               :integer          not null
#  organization_id          :integer          not null
#  language                 :string(255)
#  begin                    :date
#  end                      :date
#  capacity                 :integer
#  places                   :integer          not null
#  places_for_males         :integer          not null
#  places_for_females       :integer          not null
#  minimal_age              :integer          default(18)
#  maximal_age              :integer          default(99)
#  area                     :text
#  accommodation            :text
#  workdesc                 :text
#  notes                    :text
#  description              :text
#  created_at               :datetime
#  updated_at               :datetime
#  extra_fee                :decimal(10, 2)
#  extra_fee_currency       :string(255)
#  region                   :string(65536)
#  capacity_natives         :integer
#  capacity_teenagers       :integer
#  capacity_males           :integer
#  capacity_females         :integer
#  airport                  :string(255)
#  train                    :string(4096)
#  publish_mode             :string(255)      default("ALWAYS"), not null
#  accepted_places          :integer          default(0), not null
#  accepted_places_males    :integer          default(0), not null
#  accepted_places_females  :integer          default(0), not null
#  asked_for_places         :integer          default(0), not null
#  asked_for_places_males   :integer          default(0), not null
#  asked_for_places_females :integer          default(0), not null
#  type                     :string(255)      default("Outgoing::Workcamp"), not null
#  longitude                :decimal(11, 7)
#  latitude                 :decimal(11, 7)
#  state                    :string(255)
#  requirements             :text
#  free_places              :integer          default(0), not null
#  free_places_for_males    :integer          default(0), not null
#  free_places_for_females  :integer          default(0), not null
#  project_id               :string(255)
#  duration                 :integer
#  free_capacity_males      :integer          default(0), not null
#  free_capacity_females    :integer          default(0), not null
#  free_capacity            :integer          default(0), not null
#  partner_organization     :string(4096)
#  project_summary          :string(4096)
#
