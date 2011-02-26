require 'test_helper'

class EmailTemplateTest < ActiveSupport::TestCase

  def setup
    DataLoader.load_emails
    @submitted = EmailTemplate.find_by_action('submitted')
    @ask = EmailTemplate.find_by_action('ask')
  end

  test "that 'submitted' template is correctly wrapped and 'ask' is not" do
    assert_not_nil @submitted
    assert_equal EmailTemplate.find_by_action('mail'), @submitted.wrapped_in, 'Template is not wrapped in "mail" template'

    assert_not_nil @ask
    assert_nil @ask.wrapped_in
  end

  test "template wrapping" do
    outter = Factory.create(:email_template, :action => 'wrapping', :body => "OUTTER {{content}} OUTTER")
    inner = Factory.create(:email_template, :action => 'wrapped', :body => "INNER", :wrap_into_template => 'wrapping')

    assert_equal "OUTTER INNER OUTTER", inner.get_body
  end

  test "simple template rendering" do
    vol = Factory.create(:volunteer, :firstname => 'Jakub', :lastname => 'Hozak')
    form = Factory.create(:accepted_form, :volunteer => vol)

    et = Factory.build(:email_template,
                       :subject => '{{wc.name}} a {{volunteer.name}}',
                       :body => '{{form.general_remarks}} & Sincerely {{user.name}} or {{user.firstname}}')

    et.bind_data( "wc", form.current_workcamp)
    et.bind_data( "volunteer", form.volunteer, [ "name", "age" ])
    et.bind_data( "form", form)
    et.bind_data( "user", users(:admin), [ 'name' ])

    assert_not_nil et.get_subject
    assert_not_nil et.get_body.index('Sincerely'), 'Inner body text not found'
  end

end
