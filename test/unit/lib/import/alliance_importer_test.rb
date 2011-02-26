require 'test/test_helper'

module Import
  class AllianceImporterTest < ActiveSupport::TestCase
    context "WorkcampImport" do
      setup do
        # TODO - use factory
        Country.find_by_code('IS').update_attribute(:triple_code, 'ISL')
        Country.find_by_code('US').update_attribute(:triple_code, 'USA')
      end
      
      should "import artifficial Alliance XML" do
        result = Import::AllianceImporter.new('test/fixtures/xml/alliance_test.xml').import

        # unknown organization trigger
        assert_equal({ :unknown_organization => 'UNKNOWN!'} , result[0])

        seeds = result[1][:organization]
        assert_equal 4, seeds[:parsed_count]
        assert_equal 3, seeds[:ok_count]
        assert_equal 'Seeds', seeds[:name]

        # duplicate workcamp trigger
        existing = seeds[:workcamps][0]
        assert_equal({ :wc_already_exists => 'KTLC' }, existing)

        # wrong strange work codes shouldn't break the import
        wrong_codes = seeds[:workcamps][1]
        assert_equal false, wrong_codes.key?(:error)
        wc = Workcamp.find_by_code(wrong_codes[:workcamp][:code])
        assert_equal 0, wc.intentions.size
        assert_equal "WARNING: unknown work code 'XXX' in 'KTLC-06'", wrong_codes[:workcamp][:warnings][0]

        # check attributes
        single = seeds[:workcamps][2]
        wc = Workcamp.find_by_code(single[:workcamp][:code])
        assert_equal 'Testing 1', wc.name
        assert_equal 'TESTING1', wc.code
        assert_equal Date.new(2009,4,20), wc.begin
        assert_equal Date.new(2009,5,4), wc.end
        assert_equal 'Þórsmörk', wc.area
        assert_equal 'en', wc.language
        assert_equal 'South-west of Iceland', wc.region
        assert_not_nil wc.description
        assert_not_nil wc.notes

        assert_equal 12, wc.capacity
        assert_equal 2, wc.places

        assert_equal 18, wc.minimal_age
        assert_equal nil, wc.maximal_age
        assert_equal nil, wc.extra_fee
        assert_equal nil, wc.extra_fee_currency
        assert wc.tag_list.include?('vegetarian')

        assert_equal 5, wc.intentions.size
        wc.intentions.each do |intention|
          assert ['ENVI','RENO','CONS','STUDY','KIDS'].include?(intention.code)
        end

        # places and fee currency errors check
        place_check = seeds[:workcamps][3]
        wc = Workcamp.find_by_code(place_check[:workcamp][:code])
        assert_equal 1, wc.places
        assert_equal 1, wc.places_for_males
        assert_equal 1, wc.places_for_females
        assert_equal nil, wc.extra_fee_currency
      end

      should "import Seeds XML - real-life example" do
        result = AllianceImporter.new('test/fixtures/xml/seeds_test.xml').import
        org = result[0][:organization]

        assert_equal 'Seeds', org[:name]
        workcamps = org[:workcamps]
        assert_equal 12, workcamps.size
        workcamps.each do |wc|
          assert_not_nil wc[:workcamp]
        end
      end

      should "import Alliance with foreign apostrophes used" do
        Import::AllianceImporter.new('test/fixtures/xml/apostrophes_problem.xml').import
        wc = Workcamp.find_by_code!('JR09/307')

        Import::XmlHelper::WRONG_CHARS.each do |a|
          assert_equal false, wc.description.include?(a)
        end
      end

      should "import Alliance XML example file" do
        Workcamp.destroy_all
        result = AllianceImporter.new('test/fixtures/xml/alliance3_example.xml').import

        wc = Workcamp.find_by_code('ABC-04')
        assert_not_nil wc
        assert_equal 'ABC-04', wc.code
        assert_equal 'PEAK PARK 1 MARSH FARM', wc.name
        assert_equal 'ENVI', wc.intentions[0].code
        assert_equal Date.new(2008,1,19), wc.begin
        assert_equal Date.new(2008,1,31), wc.end
        assert_equal 'Lincoln, MA', wc.area
        assert_equal 'LAX', wc.airport
        assert_equal 'Grand Central, NY', wc.train
        assert_equal 'Maine', wc.region
        assert_equal 'US', wc.country.code
        assert_equal 'en,fr', wc.language
        assert_equal 150, wc.extra_fee
        assert_equal 'EUR', wc.extra_fee_currency
        assert_equal 18, wc.minimal_age
        assert_equal 40, wc.maximal_age
        assert wc.tag_list.include?('disabled')
        assert wc.tag_list.include?('family')
        assert_equal 14, wc.capacity
        assert_equal 7, wc.capacity_males
        assert_equal 7, wc.capacity_females
        assert_equal 4, wc.capacity_natives
        assert_equal 3, wc.capacity_teenagers
        assert_equal 2, wc.places
        assert_not_nil wc.description
        assert_not_nil wc.notes
      end
    end
  end
end
