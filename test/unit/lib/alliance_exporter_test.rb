require 'test_helper'

class AllianceExporterTest < ActiveSupport::TestCase
  context "AllianceExporter" do
    setup do
      edu = Factory.create(:edu)
      envi = Factory.create(:envi)

      @wc = Factory.create(:workcamp, :begin => Date.today,
                           :country => Factory.create(:czech_republic),
                           :begin => Date.new(2009, 12, 22),
                           :end => Date.new(2019, 1, 31),
                           :area => 'Praha',
                           :intentions => [ edu, envi],
                           :minimal_age => 18,
                           :maximal_age => 99,
                           :description => 'fasdkfh hjkshdf jkhsd fj',
                           :organization => Factory.create(:organization, :name => 'ABC'))
    end

    should "generate Alliance XML for workcamp" do
      xml = @wc.to_alliance_xml

      root = REXML::Document.new(xml).root
      pairs = [ [ @wc.name, 'name'],
                [ @wc.code, 'code'],
                [ @wc.capacity.to_s, 'numvol'],
                [ '18', 'min_age' ],
                [ '99', 'max_age' ],
                [ @wc.description, 'description' ],
                [ @wc.area, 'location' ],
                [ 'EDU,ENVI', 'work' ],
                [ 'en',    'languages'],
                [ '2009-12-22', 'start_date' ],
                [ '2019-01-31', 'end_date' ]
              ]

      pairs.each do |expected,xpath|
        assert_not_nil  root.elements[xpath], "#{xpath} node not found"
        assert_equal expected, root.elements[xpath].text
      end

      #assert_equal 'ABC', root.attributes['organization']
      assert_not_nil root.elements['description'].text
    end

    context "with many workcamps" do
      setup do
        Workcamp.destroy_all
        o1 = Factory.create(:organization, :code => 'XXX')
	2.times { Factory.create(:workcamp, :organization => o1) }
        2.times { Factory.create(:workcamp) }
      end

      should "generate XML with all organizations" do
        xml = AllianceExporter.export(Workcamp.find(:all))
        root = REXML::Document.new(xml).root
        assert_not_nil root.elements["//workcamps[@organization='XXX']"]
      end
    end
  end
end
