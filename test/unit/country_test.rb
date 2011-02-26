require 'test/test_helper'

class CountryTest < ActiveSupport::TestCase

  test "naming" do
    cz = Country.find_by_code('CZ')
    assert_equal "Česko", cz.name
  end

  test "find Autria" do
    at = Country.find_by_code('AT')
    assert_equal "Rakousko", at.name
  end

  test "find used countries" do
    assert_equal 1, Country.find_those_with_orgs.size
  end

  test "conversion to XML" do
    at = Country.find_by_code('AT')
    assert_not_nil at.to_xml
  end

end
