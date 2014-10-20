# -*- coding: utf-8 -*-
require 'test_helper'

class CountryTest < ActiveSupport::TestCase

  setup do
    I18n.default_locale = :en
  end

  test "naming" do
    cz = Country.find_by_code('CZ')
    assert_equal "Czechia", cz.name
  end

  test "find Austria" do
    at = Country.find_by_code('AT')
    assert_equal "Austria", at.name
  end

  test "conversion to XML" do
    at = Country.find_by_code('AT')
    assert_not_nil at.to_xml
  end

end
