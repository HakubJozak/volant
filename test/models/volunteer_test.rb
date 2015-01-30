# -*- coding: utf-8 -*-
require 'test_helper'

class VolunteerTest < ActiveSupport::TestCase

  def setup
    @jakub = Factory.create(:male, :firstname => 'Jakub', :lastname => 'Hozak')
    @hana = Factory.create(:female, :firstname => 'Hana', :lastname => 'Hozakova')
  end


  test "age computation" do
    @jakub.birthdate = Date.new(1995,1,30)
    assert_equal 14, @jakub.age(Date.new(2009,1,31))
    assert_equal 1, @jakub.age(Date.new(1997,1,29))
    assert_equal 0, @jakub.age(Date.new(1996,1,25))
  end

  test "schema driven validation" do
    assert_validates_presence_of @jakub, :firstname, :lastname, :gender, :email
  end

  test "gender validation" do
    @jakub.gender = 'wrong value'
    assert_invalid @jakub, :gender
  end

  test "male? method " do
    assert_equal true, @jakub.male?
    assert_equal false, @hana.male?
  end

  test "approximate find" do
    assert_equal @jakub, Volunteer.find_by_name_like('JaK')[0]
    assert_equal @hana, Volunteer.find_by_name_like('hAna')[0]
    assert_equal 2, Volunteer.find_by_name_like('hozak').size
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
    existing = { "firstname" => 'Jakub', "lastname" => 'Hozak', "birthnumber" => '8203270438', :phone => '111' }
     volunteer, code = Volunteer.create_or_update(existing)
    assert_equal @jakub, volunteer
    assert_equal :updated, code
    assert_equal '111', volunteer.phone
    assert_equal 'Jakub', volunteer.firstname
    assert_equal 'Hozak', volunteer.lastname
  end

  test "create_or_update volunteer with wrong name" do
    wrong_name = { "firstname" => 'Kakub', "lastname" => 'Hozak', "birthnumber" => '8203270438' }
    volunteer, code = Volunteer.create_or_update(wrong_name)
    assert_equal code, :created_but_uncertain
  end

  test "create volunteer with conflicting name" do
    to_create = { "firstname" => 'Jakub', "lastname" => 'Hozak', "birthnumber" => '8202122222' }
    volunteer, code = Volunteer.create_or_update(to_create)
    assert_equal code, :created
  end

  test "update volunteer - name with case and diacritics differences" do
    existing = { "firstname" => 'jakub', "lastname" => 'hozák', "birthnumber" => '8203270438' }
    assert_equal Volunteer.create_or_update(existing), [ @jakub, :updated ]
  end

end
