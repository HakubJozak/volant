# -*- coding: utf-8 -*-
require 'test_helper'

module Import
  class PefImporterTest < ActiveSupport::TestCase

    fixtures :organizations

    setup do
      Factory(:country, code: 'EE', triple_code: 'EST',name_en: 'Estonia')
      Factory(:country, code: 'US', triple_code: 'USA')
      Factory(:country, code: 'DN', triple_code: 'DNK', name_en: 'Denmark')      
    end

    # http://redmine.siven.onesim.net/issues/1366
    test "empty organization code" do
      invalid = """
      <projectform>
        <organization_code>  </organization_code>
        <projects>
          <project id='25493'></project>
        </projects>
      </projectform>
      """

      importer = PefImporter.new(invalid)

      message = nil
      importer.import! {|level,msg| message = msg }
      assert_equal  "Unknown organization",message
    end

    test "missing organization" do
      importer = PefImporter.new xml_file('pef2011-errors.xml')
      message = nil
      importer.import! {|level,msg| message = msg }
      assert_equal  "Unknown organization",message
    end

    test "import real-life file" do
      wcs = Import::PefImporter.new(xml_file('pef2011.xml')).import!

      assert_equal 2, wcs.size

      wc = wcs.first
      assert wc.imported?
      assert_equal 'EST', wc.organization.code
      assert_equal 'Estonia', wc.country.name
      assert_equal false, wc.tag_list.include?('disabled')
      assert_equal false, wc.tag_list.include?('family')
      assert_equal wc.intentions.size, 1

      expected = {
        code: 'EST T5',
        name: 'WHV DOWN TOWN TALLINN',
        language: 'eng,eng',
        extra_fee: 200,
        workdesc: 'work_is_hard',
        places: 2,
        places_for_females: 2,
        places_for_males: 2,
        # TODO remove the newlines
        notes: "must_be_alive\n\n",
        extra_fee_currency: 'EUR',
        begin: Date.new(2011,7,25),
        end: Date.new(2011,8,7),
        minimal_age: 14,
        maximal_age: 17,
        longitude: 24.7544715,
        latitude: 59.4388619
      }

      expected.each do |attr,expected|
        assert_equal expected, wc.send(attr), "#{attr} is incorrect"
      end
    end

    test 'import project_id' do
      importer = Import::PefImporter.new(xml_file('PEF_lunar31_20141112.xml'))
      wc = importer.import!.first
      assert_equal wc.project_id, 'f9c91026d627166ce372501d4c55f690'
    end

    test 'report missing project_id' do
      importer = Import::PefImporter.new(xml_file('pef_missing_project_id.xml'))
      messages = []
      importer.import! {|l,m| messages << [l,m] }

      assert_equal [[:warning, "Workcamp 'LUNAR 31 - AGAPE 06' is missing project_id attribute."],
                    [:success, "Workcamp AGAPE 06(LUNAR 31) prepared for creation."]],messages
    end


    test "detect duplicates" do
      file = File.new(xml_file('PEF_lunar31_20141112.xml'))
      wcs = Import::PefImporter.new(file).import!
      assert_equal 'imported',wcs.first.state

      wcs = Import::PefImporter.new(xml_file('pef_changed_name.xml')).import!
      assert_equal 'updated',wcs.first.state
      assert wcs.first.import_changes.map(&:field).include?('name')
    end

    test "import LTV" do
      Import::PefImporter.new(xml_file('PEF_lunar31_20141112.xml'), Ltv::Workcamp).import!.first
      assert_not_nil wc = Ltv::Workcamp.find_by_project_id('f9c91026d627166ce372501d4c55f690')
    end

    test 'pef 2016' do
      file = xml_file('pef_2016.xml')
      wc = Import::PefImporter.new(file).import!.first

      assert_equal 'EST', wc.organization.code
      assert_equal 'Estonia', wc.country.name
      assert_equal 1, wc.intentions.size
      assert_equal 'Talinn', wc.train
      assert_equal 'ESTYES is an organization.',
                   wc.partner_organization
      assert_equal 'bla bla bla...', wc.project_summary
      assert_equal 200, wc.extra_fee
      assert_equal 'EUR', wc.extra_fee_currency

      assert wc.tag_list.include?('disabled')
      refute wc.tag_list.include?('family')
    end


    test 'pef 2017' do
      create :organization, code: 'MS'
      file = xml_file('PEF_MS_20170301.xml')
      importer = Import::PefImporter.new(file)

      wcs = importer.import!

      assert_equal 12, wcs.size
      assert_not_nil wc = Workcamp.
                          find_by_project_id('0140bcdf2bbb4e6b9a3a2a5567984d5d')

      assert_match /^Skælskør Landevej 28, 4200 Slagelse/, wc.area
      assert_equal 18, wc.minimal_age
      assert_equal 'Denmark', wc.country.name_en
    end

    private

    def xml_file(name)
      File.new(Rails.root.join("test/fixtures/pef/#{name}"))
    end

  end
end
