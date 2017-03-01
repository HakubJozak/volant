# -*- coding: utf-8 -*-
require 'test_helper'

module Import
  class VefImporterTest < ActiveSupport::TestCase

    fixtures :organizations

    setup do
      seed_countries
    end

    test 'import' do
      i = VefImporter.new xml_file('vef_sda_josef_herout.xml')
      assert_not_nil apply_form = i.import

      assert_equal 'Vyšmejdil', apply_form.lastname
      assert_equal Date.new(1977, 1, 12), apply_form.birthdate
      assert_equal 'Prague', apply_form.birthplace

      assert_equal 'Praha 9', apply_form.city
      assert_equal 'Makedonská 88,Praha 9', apply_form.street

      assert_equal 'Londýnská 33,Praha 9', apply_form.contact_street
      assert_equal 10100, apply_form.zipcode
    end

    private

    def xml_file(name)
      File.new("test/fixtures/vef/#{name}")
    end

  end
end
