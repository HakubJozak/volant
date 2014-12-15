# -*- coding: utf-8 -*-
require 'test_helper'

class V1::ApplyFormsControllerTest < ActionController::TestCase
  setup do
    @camps = 12.times.map { Factory(:outgoing_workcamp) }
    @attrs = {
      volunteer_attributes: {
        # 'm' or 'f'
        gender: 'm',
        firstname: 'Anton',
        lastname: 'Špelec',
        birthnumber: '0103260424',
        nationality: 'Austrian-Hungarian',
        birthdate: '27-05-1901',
        birthplace: 'Wien',
        occupation: 'Ostrostřelec',
        email: 'anton.spelec@gmail.com',
        phone: '+420 777 123 456',
        fax: "I do not own such device",
        emergency_day: '+420 777 999 999',
        emergency_night: '+420 777 999 999',
        emergency_name: 'Yo Mama',
        speak_well: 'Český a Maďarský',
        speak_some: 'Dojč',
        past_experience: 'I used to shoot things 100 years ago.',
        general_remarks: 'vegetarian',
        workcamp_ids: @camps.map(&:id)
      }
    }
  end

  test 'create' do
    assert_difference('Outgoing::ApplyForm.count') do
      post :create, apply_form: @attrs
      assert_response :success, response.body.to_s
    end

    form = Outgoing::ApplyForm.joins(:volunteer).where(people: { birthnumber: '0103260424'}).first
    assert_not_nil form
    assert_equal 'Anton',form.volunteer.firstname
    assert_equal 'Špelec',form.volunteer.lastname
    assert_equal :not_paid, form.state.name
    assert_equal '0103260424', form.volunteer.birthnumber
  end

  test 'create: birthnumber validation' do
    @attrs[:volunteer_attributes][:birthnumber] = '010326/0424'
    post :create, apply_form: @attrs
    assert_not_nil json['errors']['volunteer.birthnumber']
  end

  test 'create: assign old volunteer' do
    old = Factory(:volunteer, birthnumber: '0103260424')
  end

end
