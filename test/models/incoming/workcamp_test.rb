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
    wc = Incoming::Workcamp.create!(name: 'Some',
                                    code: 'SOM',
                                    begin: Date.today,
                                    end: 10.days.from_now,
                                    places: 2,places_for_males: 2,
                                    places_for_females: 2,
                                    country: countries(:AT),
                                    organization: Organization.first)
    assert_equal '4e162d60aa68605f2d425e9da678cca4', wc.project_id
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


end
