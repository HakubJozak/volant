require 'test/test_helper'

class Public::CountryCartTest < ActiveSupport::TestCase

  def setup
    @cart = Public::CountryCart.new
  end

  def test_country_handling
    austria = Country.find_by_code('AT')
    @cart.add_country(austria)
    assert_equal austria, @cart.countries.first
    @cart.remove_country('AT')
    assert @cart.country_codes.empty?
  end

end
