# -*- coding: utf-8 -*-
require 'test/test_helper'

module Import
  class PefImporterTest < ActiveSupport::TestCase
    context "WorkcampImport" do
      setup do
        # TODO - use factory
        Country.find_by_code('EE').update_attribute(:triple_code, 'EST')
        Country.find_by_code('US').update_attribute(:triple_code, 'USA')
      end

      should "import real-life example" do
        wcs = PefImporter.new('test/fixtures/xml/pef2011.xml').import!
        assert_equal 30, wcs.size

        wc = wcs.first
        assert_equal 'EST', wc.organization.code
        assert_equal 'Estonsko', wc.country.name
        assert wc.tag_list.include?('teenage')
        assert wc.tag_list.include?('extra fee')
        assert_equal false, wc.tag_list.include?('disabled')
        assert_equal false, wc.tag_list.include?('family')

        expected = {
          :code => 'EST T5',
          :name => 'WHV DOWN TOWN TALLINN',
          :language => 'eng,eng',
          :extra_fee => 200,
          :extra_fee_currency => 'EUR',
          :begin => Date.new(2011,7,25),
          :end => Date.new(2011,8,7),
          :minimal_age => 14,
          :maximal_age => 17
        }

        expected.each do |attr,value|
          assert_equal value,
                       wc.send(attr),
                       "#{attr} is expected to be #{value}"
        end


      end

    end
  end
end
