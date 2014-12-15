# -*- coding: utf-8 -*-
require 'test_helper'

class V1::ApplyFormsControllerTest < ActionController::TestCase
  setup do
    @camps = 12.times.map { Factory(:outgoing_workcamp) }
  end

  test 'create' do
    attrs = {
      volunteer_attributes: {
        # 'm' or 'f'
        gender: 'm',
        firstname: 'Anton',
        lastname: 'Špelec',
        birthnumber: '010326/0424',
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

    assert_difference('Outgoing::ApplyForm.count') do
      post :create, apply_form: attrs
      assert_response :success, response.body.to_s
    end

    form = Outgoing::ApplyForm.joins(:volunteer).where(people: { birthnumber: '010326/0424'}).first
    assert_not_nil form
    assert_equal 'Anton',form.volunteer.firstname
    assert_equal 'Špelec',form.volunteer.lastname
    assert_equal :not_paid, form.state.name
  end

end
