# -*- coding: utf-8 -*-
require 'test_helper'

class V1::ApplyFormsControllerTest < ActionController::TestCase
  setup do
    DataLoader.load_emails

    @camps = []
    @attrs = {
      past_experience: 'I used to shoot things 100 years ago.',
      general_remarks: 'vegetarian',
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
      workcamp_ids: @camps,
      street: 'Ulise v Prace 22',
      city: 'Prag',
      zipcode: '00001',
      motivation: 'Ich mochte gehen na workcamp.'
    }
  end

  test 'create' do
    assert_difference('Outgoing::ApplyForm.count') do
      12.times.each { @camps << Factory(:outgoing_workcamp) }

      post :create, apply_form: @attrs

      assert_response :success, response.body.to_s
      assert_not_nil form = form_by_birthnumber('0103260424')
      assert_equal 'Anton',form.volunteer.firstname
      assert_equal 'Špelec',form.volunteer.lastname
      assert_equal :not_paid, form.state.name
      assert_equal '0103260424', form.volunteer.birthnumber
    end
  end


  test 'create ltv' do
    assert_difference('Ltv::ApplyForm.count') do
      12.times.each { @camps << Factory(:ltv_workcamp) }
      
      post :create, apply_form: @attrs

      assert_response :success, response.body.to_s
      assert_not_nil form = form_by_birthnumber('0103260424')
      assert_equal 'Anton',form.volunteer.firstname
      assert_equal 'Špelec',form.volunteer.lastname
      assert_equal :not_paid, form.state.name
      assert_equal '0103260424', form.volunteer.birthnumber
    end
  end

  
  test 'create: birthnumber validation' do
    @attrs[:birthnumber] = '010326/0424'
    post :create, apply_form: @attrs
    assert_not_nil json['errors']['volunteer.birthnumber']
  end

  test 'create: validation' do
    attrs = [ :firstname, :lastname, :birthnumber, :occupation, :birthdate, :email,
              :phone, :gender, :street, :city, :zipcode, :emergency_name, :emergency_day,
            ]
      attrs.each do |attr|
      @attrs[attr] = ''
      post :create, apply_form: @attrs
      assert_not_nil json['errors']["volunteer.#{attr}"],
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

  private

  def form_by_birthnumber(bn)
    Outgoing::ApplyForm.joins(:volunteer).where(people: { birthnumber: bn}).first
  end

end
