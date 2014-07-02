# -*- coding: utf-8 -*-
require 'test_helper'

class CountryTest < ActiveSupport::TestCase

  setup do
    I18n.default_locale = :cz
  end

  test "naming" do
    cz = Country.find_by_code('CZ')
    assert_equal "Česko", cz.name
  end

  test "find Autria" do
    at = Country.find_by_code('AT')
    assert_equal "Rakousko", at.name
  end

  test "conversion to XML" do
    at = Country.find_by_code('AT')
    assert_not_nil at.to_xml
  end

end
