require 'test_helper'
require "#{RAILS_ROOT}/test/functional/restful_controller_test"

class RestfulApplyFormsControllerTest < RestfulControllerTest

  def setup
    super
    @form = {
      :firstname => 'eee',
      :lastname => 'eee',
      "birthnumber" => '1111111111',
      :gender => 'm',
      :email => 'eee',
      :cellphone => 'eee',
      :nationality => 'eee',
      :street => 'eee', :city => 'eee', :zipcode => 'eee',
      "workcamps_ids" => [ workcamps(:kytlice).id, workcamps(:xaverov).id ]
    }
  end

  test "application submission with fresh new volunteer" do
    post :create, :apply_form => { :apply_form => @form }
    assert_response :success

    form = assigns(:apply_form)
    assert_not_nil form.volunteer

    assert_not_empty form.workcamps(true)
    assert (not form.tags.include?(Tag.find_by_name(Outgoing::ApplyForm::POSSIBLE_DUPLICATE)))
  end

  test "application with old volunteer but wrong name" do
    Factory.create(:volunteer, :lastname => 'Hozak', :birthnumber => "8203270438")
    @form.update "firstname" => 'Jakub', "lastname" => 'Hozakkk', "birthnumber" => "8203270438"
    post :create, :apply_form => { :apply_form => @form }
    assert_response :success

    created = assigns(:apply_form)
    assert_not_nil created
    assert_not_empty created.workcamps(true)
    assert created.tag_list.include?(Outgoing::ApplyForm::POSSIBLE_DUPLICATE)
  end  

  test "REST routing of apply forms" do
    params = { :controller => 'RestfulApplyForms', :action => 'create', :format => 'xml' }
    assert_recognizes params, { :path => '/rest/apply_forms.xml', :method => :post }
  end

end
