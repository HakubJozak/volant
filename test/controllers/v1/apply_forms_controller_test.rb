# -*- coding: utf-8 -*-
require 'test_helper'

class V1::ApplyFormsControllerTest < ActionController::TestCase
  setup do
    Factory(:email_template,action: 'submitted')
    Factory(:email_template,action: 'ltv/submitted',body: 'LTV')

    @attrs = {
      past_experience: 'I used to shoot things 100 years ago.',
      general_remarks: 'vegetarian',
      special_needs: 'eggnog',
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
      street: 'Ulise v Prace 22',
      city: 'Prag',
      zipcode: '00001',
      motivation: 'Ich mochte gehen na workcamp.'
    }
  end

  test 'create' do
    assert_difference('Outgoing::ApplyForm.count') do
      camps = 3.times.map { Factory(:outgoing_workcamp).id }

      post :create, apply_form: @attrs.merge(workcamp_ids: camps)

      assert_response :success, response.body.to_s
      assert_not_nil form = form_by_birthnumber('0103260424')
      assert_equal 'Anton',form.volunteer.firstname
      assert_equal 'Špelec',form.volunteer.lastname
      assert_equal :not_paid, form.state.name
      assert_equal '0103260424', form.volunteer.birthnumber
      assert_equal 3, form.workcamps.reload.count
      assert_equal form.general_remarks, 'vegetarian'
      assert_equal form.past_experience, 'I used to shoot things 100 years ago.'
      assert_equal form.special_needs, 'eggnog'
    end
  end


  test 'create LTV' do
    assert_difference('Ltv::ApplyForm.count') do
      camps = 5.times.map { Factory(:ltv_workcamp).id }

      post :create, apply_form: @attrs.merge(type: 'ltv', workcamp_ids: camps)

      assert_response :success, response.body.to_s
      assert_not_nil form = form_by_birthnumber('0103260424')
      assert_equal 'Anton',form.volunteer.firstname
      assert_equal 'Špelec',form.volunteer.lastname
      assert_equal :not_paid, form.state.name
      assert_equal '0103260424', form.volunteer.birthnumber
      assert_equal Ltv::ApplyForm, form.class
    end
  end


  test 'create: birthnumber validation' do
    @attrs[:birthnumber] = '010326/0424'
    post :create, apply_form: @attrs
    assert_not_nil json[:errors][:'volunteer.birthnumber']
  end

  test 'create: validation' do
    attrs = [ :firstname, :lastname, :birthnumber, :occupation, :birthdate, :email,
              :phone, :gender, :street, :city, :zipcode, :emergency_name, :emergency_day,
            ]
      attrs.each do |attr|
      @attrs[attr] = ''
      post :create, apply_form: @attrs
      assert_not_nil json[:errors][:"volunteer.#{attr}"],
                     "Presence of #{attr} was not validated"
    end

  end

  test 'create: update old volunteer data' do
    old = Factory(:volunteer, birthnumber: '0103260424', firstname: 'OldName')

    post :create, apply_form: @attrs

    assert_not_nil form = form_by_birthnumber('0103260424')
    assert_equal 'Anton',form.volunteer.firstname
    assert_equal old.id,form.volunteer.id
  end

  test 'create LTV: update old volunteer data' do
    assert_difference('Ltv::ApplyForm.count') do
      camps = 5.times.map { Factory(:ltv_workcamp).id }
      old = Factory(:volunteer, birthnumber: '0103260424', firstname: 'OldName')

      post :create, apply_form: @attrs.merge(type: 'ltv', workcamp_ids: camps)

      assert_not_nil form = form_by_birthnumber('0103260424')
      assert_equal 'Anton',form.volunteer.firstname
      assert_equal old.id,form.volunteer.id
      assert_equal 5, form.workcamps.size
      assert_equal Ltv::ApplyForm, form.class
    end
  end

  test 'phone numbers validation' do
    [ :phone, :emergency_day, :emergency_night ].each do |attr|
      [ '+420/123456789','+420 123 456 789','0034-21-34-56','+420123456789', '123456789' ].each do |valid|
        post :create, apply_form: { attr => valid }
        refute json[:errors][:"volunteer.#{attr}"], "#{attr} should be valid (#{valid})"
      end

      [ '+420', 'invalid', '123'].each do |invalid_number|
        post :create, apply_form: { attr => invalid_number }
        assert_response 422
        errors = json[:errors][:"volunteer.#{attr}"]
        assert_not_empty errors
        assert_match /should be formatted like/,errors.first, "#{attr} does not validate against #{invalid_number}"
      end
    end

  end
  

  private

  def form_by_birthnumber(bn)
    ApplyForm.joins(:volunteer).where(people: { birthnumber: bn}).first
  end

end
