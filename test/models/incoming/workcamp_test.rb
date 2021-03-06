require 'test_helper'


class Incoming::WorkcampTest < ActiveSupport::TestCase

  setup do
    @wc = Factory.create(:incoming_workcamp)
  end

  test 'project_id of invalid workcamp' do
    wc = Incoming::Workcamp.create(name: 'Some')
    refute wc.save
    assert_nil wc.project_id
  end

  test 'project_id' do
    today = Date.new(2015,2,28)
    wc = Incoming::Workcamp.create!(name: 'Some',
                                    code: 'SOM',
                                    begin: today,
                                    end: today + 10.days,
                                    places: 2,places_for_males: 2,
                                    places_for_females: 2,
                                    country: countries(:AT),
                                    organization: Organization.first)
    assert_equal '6028cfc772fa77c2f34c7d0061b6583c', wc.project_id
  end


  context "with participants" do
    setup do
      @wc.participants << Factory.create(:participant, :birthdate => nil)
      3.times { @wc.participants << Factory.create(:participant) }
      @wc.participants << Factory.create(:participant,
                                         :birthdate => 30.years.ago,
                                         :country => Factory.create(:country, :name_cz => 'XXX'),
                                         :organization => Factory.create(:organization, :name => 'YYY'),
                                         :firstname => 'Jakub',
                                         :lastname => 'Hozak',
                                         :gender => Person::MALE
                                         )
    end

      should "export participants to CSV file" do
        skip 'not implemented yet'
        csv = @wc.participants_to_csv
        assert_not_nil csv

        lines = csv.split("\n")
        assert_equal @wc.participants.size + 1, lines.count

        assert_equal lines.first.strip, 'Organization;Country;Nationality;Name;Gender;Age;Birthdate;Tags;Emergency name;Emergency day;Emergency night'
      end

      context "with free workcamps" do
        setup do
          Incoming::Workcamp.destroy_all
          2.times { Factory.create(:incoming_workcamp, :capacity => -1) }

          wc = Factory.create(:incoming_workcamp, :capacity => 10)
          2.times { wc.participants << Factory.create(:participant, :nationality => 'Korean') }

          wc = Factory.create(:incoming_workcamp, :capacity => 10)
          1.times { wc.participants << Factory.create(:participant, :nationality => 'Icelandic') }
        end

        should "create Friday list" do
          skip 'not implemented yet'
          assert_not_nil csv
          assert_equal 3, csv.split("\n").count
          assert_not_nil csv.index('Korean')
          assert_nil csv.index('Icelandic')
        end
      end
    end

  # regression test for http://redmine.siven.onesim.net/issues/1479
  test 'order by code' do
    Incoming::Workcamp.destroy_all    
    second = Factory(:incoming_workcamp,begin: Date.new(2014,1,1), code: 'BBB')
    first = Factory(:incoming_workcamp,begin: Date.new(2015,1,1), code: 'AAA')
    
    assert_equal [first.id,second.id], Incoming::Workcamp.all.order(:code).map(&:id)
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
