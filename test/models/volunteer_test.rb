# -*- coding: utf-8 -*-
require 'test_helper'

class VolunteerTest < ActiveSupport::TestCase

  def setup
    @jim = Factory.create(:male, :firstname => 'Jim', :lastname => 'Doe')
    @jane = Factory.create(:female, :firstname => 'Jane', :lastname => 'Doe')
  end


  test "age computation" do
    @jim.birthdate = Date.new(1995,1,30)
    assert_equal 14, @jim.age(Date.new(2009,1,31))
    assert_equal 1, @jim.age(Date.new(1997,1,29))
    assert_equal 0, @jim.age(Date.new(1996,1,25))
  end

  test "schema driven validation" do
    assert_validates_presence_of @jim, :firstname, :lastname, :gender, :email
  end

  test "gender validation" do
    @jim.gender = 'wrong value'
    assert_invalid @jim, :gender
  end

  test "male? method " do
    assert_equal true, @jim.male?
    assert_equal false, @jane.male?
  end

  test "approximate find" do
    assert_equal @jim, Volunteer.find_by_name_like('Ji')[0]
    assert_equal @jane, Volunteer.find_by_name_like('jane')[0]
    assert_equal 2, Volunteer.find_by_name_like('doe').size
  end

  test "create fresh new volunteer" do
    unknown = { "firstname" => 'someone', "lastname" => "else", "birthnumber" => '111111111' }
    volunteer, code = Volunteer.create_or_update(unknown)
    assert_equal :created, code
    assert_equal 'someone', volunteer.firstname
    assert_equal '111111111', volunteer.birthnumber
    assert_equal 'else', volunteer.lastname
  end

  test 'birthumber validation' do
    v = Factory.build(:volunteer, birthnumber: '820327/0438')
    refute v.valid?
    assert_not_empty v.errors[:birthnumber]

    v.birthnumber = '8203270438'
    assert v.valid?
    assert_empty v.errors[:birthnumber]
  end

  test "update existing volunteer found by birthnumber" do
    existing = { "firstname" => 'Jim', "lastname" => 'Doe', "birthnumber" => '1234560789', :phone => '111' }
     volunteer, code = Volunteer.create_or_update(existing)
    assert_equal @jim, volunteer
    assert_equal :updated, code
    assert_equal '111', volunteer.phone
    assert_equal 'Jim', volunteer.firstname
    assert_equal 'Doe', volunteer.lastname
  end

  test "create_or_update volunteer with wrong name" do
    wrong_name = { "firstname" => 'Kakub', "lastname" => 'doe', "birthnumber" => '1234560789' }
    volunteer, code = Volunteer.create_or_update(wrong_name)
    assert_equal code, :created_but_uncertain
  end

  test "create volunteer with conflicting name" do
    to_create = { "firstname" => 'Jakub', "lastname" => 'umbridge', "birthnumber" => '8202122222' }
    volunteer, code = Volunteer.create_or_update(to_create)
    assert_equal code, :created
  end

end
# == Schema Information
#
# Table name: people
#
#  id                  :integer          not null, primary key
#  firstname           :string(255)      not null
#  lastname            :string(255)      not null
#  gender              :string(255)      not null
#  old_schema_key      :integer
#  email               :string(255)
#  phone               :string(255)
#  birthdate           :date
#  birthnumber         :string(255)
#  nationality         :string(255)
#  occupation          :string(255)
#  account             :string(255)
#  emergency_name      :string(255)
#  emergency_day       :string(255)
#  emergency_night     :string(255)
#  speak_well          :string(255)
#  speak_some          :string(255)
#  special_needs       :text
#  past_experience     :text
#  comments            :text
#  created_at          :datetime
#  updated_at          :datetime
#  fax                 :string(255)
#  street              :string(255)
#  city                :string(255)
#  zipcode             :string(255)
#  contact_street      :string(255)
#  contact_city        :string(255)
#  contact_zipcode     :string(255)
#  birthplace          :string(255)
#  type                :string(255)      default("Volunteer"), not null
#  workcamp_id         :integer
#  country_id          :integer
#  note                :text
#  organization_id     :integer
#  passport_number     :string(255)
#  passport_issued_at  :date
#  passport_expires_at :date
#
