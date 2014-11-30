# -*- coding: utf-8 -*-
require 'test_helper'

module Import
  class PefImporterTest < ActiveSupport::TestCase

    fixtures :organizations

    setup do
      Factory(:country, code: 'EE', triple_code: 'EST',name_en: 'Estonia')
      Factory(:country, code: 'US', triple_code: 'USA')
    end

    test "raise for missing organization" do
      importer = PefImporter.new(File.new('test/fixtures/xml/pef2011-errors.xml'))
      assert_raises(Import::Error) {
        importer.import!
      }
    end

    test "import real-life file" do
      file = File.new(Rails.root.join('test/fixtures/xml/pef2011.xml'))
      wcs = Import::PefImporter.new(file).import!

      assert_equal 2, wcs.size

      wc = wcs.first
      assert wc.imported?
      assert_equal 'EST', wc.organization.code
      assert_equal 'Estonia', wc.country.name
      assert wc.tag_list.include?('teenage')
      assert wc.tag_list.include?('extra fee')
      assert_equal false, wc.tag_list.include?('disabled')
      assert_equal false, wc.tag_list.include?('family')
      assert_equal wc.intentions.size, 1


      expected = {
        :code => 'EST T5',
        :name => 'WHV DOWN TOWN TALLINN',
        :language => 'eng,eng',
        :extra_fee => 200,
        :workdesc => 'work_is_hard',
        # TODO remove the newlines
        :notes => "must_be_alive\n\n",
        :extra_fee_currency => 'EUR',
        :begin => Date.new(2011,7,25),
        :end => Date.new(2011,8,7),
        :minimal_age => 14,
        :maximal_age => 17,
        :longitude => 24.7544715,
        :latitude => 59.4388619
      }

      expected.each do |attr,expected|
        assert_equal expected, wc.send(attr)
      end
    end

    test 'import project_id' do
      file = File.new(Rails.root.join('test/fixtures/xml/PEF_lunar31_20141112.xml'))
      wc = Import::PefImporter.new(file).import!.first
      assert_equal wc.project_id, 'f9c91026d627166ce372501d4c55f690'
    end

    test 'raise on missing project_id' do
      begin
        file = File.new(Rails.root.join('test/fixtures/xml/pef_missing_project_id.xml'))
        wc = Import::PefImporter.new(file).import!.first
        flunk 'importer did not raise any error'
      rescue Import::Error => e
        assert_equal "Workcamp 'LUNAR 31 - AGAPE 06' is missing project_id attribute.",e.message
      end
    end


    # test "don't create duplicates" do

    #   file = File.new(Rails.root.join('test/fixtures/xml/PEF_lunar31_20141112.xml'))
    #   wcs = Import::PefImporter.new(file).import!
    #   puts wcs.first.inspect


    #   wcs = Import::PefImporter.new(file).import!
    #   puts wcs.first.inspect
    # end

  end
end
