require 'test_helper'

class ApplyFormMailerTest < ActionMailer::TestCase
  test 'submitted' do
    form = Factory(:apply_form)
    tmpl = Factory(:email_template,action: 'submitted')

    mail = ApplyFormMailer.submitted(form)
    assert_equal mail.mime_type, 'text/html'
    assert_equal mail.body, 'Body is not important'
  end

  test 'submitted LTV' do
    form = Factory(:paid_ltv_form)
    tmpl = Factory(:email_template,action: 'ltv/submitted',body: 'LTV')

    mail = ApplyFormMailer.submitted(form)
    assert_equal mail.mime_type, 'text/html'
    assert_equal mail.body, 'LTV'    
  end
end
