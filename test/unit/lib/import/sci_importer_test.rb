# -*- coding: utf-8 -*-
require 'test/test_helper'

module Import
  class SciImporterTest < ActiveSupport::TestCase
    context "SciImporter" do

      setup do
        # TODO - use factory
        Country.find_by_code('AT').update_attribute(:name_en, 'Austria')
        Country.find_by_code('AU').update_attribute(:name_en, 'Australia')
      end


      should 'handle correct file ' do
        wcs = SciImporter.new(File.new('test/fixtures/sci/2011.csv')).import!
        assert_equal 2, wcs.size

        wc = wcs.first
        assert wc.imported?
        assert_equal 'Camp Breakaway', wc.name
        assert_equal 'Austrálie', wc.country.name_cz
        assert_equal Date.new(2011,5,18), wc.begin
        assert_equal Date.new(2011,5,29), wc.end
      end
    end
  end
end
