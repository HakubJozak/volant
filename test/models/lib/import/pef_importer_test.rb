# -*- coding: utf-8 -*-
require 'test_helper'

module Import
  class PefImporterTest < ActiveSupport::TestCase

    fixtures :organizations

    setup do
      Country.find_by_code('EE').update_attribute(:triple_code, 'EST')
      Country.find_by_code('US').update_attribute(:triple_code, 'USA')
    end

    test "not choke on missing organization" do
      skip 'blah'
      errors = 0
      importer = PefImporter.new(File.new('test/fixtures/xml/pef2011-errors.xml'))

      wcs = importer.import! do |type, msg|
        assert_equal 'Unknown organization', msg
        errors += 1
      end

      assert_equal 1, errors
      assert_equal 0, wcs.size
    end

    test "import real-life file" do
      file = File.new(Rails.root.join('test/fixtures/xml/pef2011.xml'))
      wcs = Import::PefImporter.new(file).import!

      assert_equal 2, wcs.size

      wc = wcs.first
      assert wc.imported?
      assert_equal 'EST', wc.organization.code
      assert_equal 'Estonsko', wc.country.name
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


  end
end
