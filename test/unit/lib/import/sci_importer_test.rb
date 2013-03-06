# -*- coding: utf-8 -*-
require 'test/test_helper'

module Import
  class SciImporterTest < ActiveSupport::TestCase
    context "SciImporter" do

      FILE = 'test/fixtures/sci/2011.csv'

      setup do
        # TODO - remove it after fixtures removal
        Outgoing::Workcamp::destroy_all
        # TODO - use factory
        Country.find_by_code('AT').update_attribute(:name_en, 'Austria')
        Country.find_by_code('AU').update_attribute(:name_en, 'Australia')
      end


      should 'handle correct file' do
        wcs = Import::SciImporter.new(File.new(FILE)).import!
        assert_equal 2, wcs.size

        wc = wcs.first
        assert wc.imported?
        assert_equal 'Camp Breakaway', wc.name
        assert_equal 'Austrálie', wc.country.name_cz
        assert_equal wc.intentions.first.code, 'CULT'
        assert_equal Date.new(2011,5,18), wc.begin
        assert_equal Date.new(2011,5,29), wc.end
        assert_equal 2, Outgoing::Workcamp::count
      end

      should 'create new and prepared update of existing' do
        assert_equal 0, Outgoing::Workcamp::count
        created = Import::SciImporter.new(File.new(FILE)).import!
        created.first.update_attribute(:name, 'old name')

        updated = Import::SciImporter.new(File.new(FILE)).import!
        updated.first.import_changes

        assert_equal 1, changes.size
        assert_equal 'name', changes.first.field
      end
    end
  end
end
