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

# == Schema Information
#
# Table name: countries
#
#  id                   :integer          not null, primary key
#  code                 :string(2)        not null
#  name_cz              :string(255)
#  name_en              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  triple_code          :string(3)
#  region               :string(255)      default("1"), not null
#  country_zone_id      :integer
#  free_workcamps_count :integer          default(0)
#  free_ltvs_count      :integer          default(0)
#
