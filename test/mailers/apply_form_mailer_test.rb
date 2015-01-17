require 'test_helper'

class ApplyFormMailerTest < ActionMailer::TestCase
  test 'submitted' do
    form = Factory(:apply_form)
    tmpl = Factory(:email_template,action: 'submitted')
    
    mail = ApplyFormMailer.submitted(form)
    assert_equal mail.mime_type, 'text/html'
    assert_equal mail.body, 'Body is not important'
  end
end
