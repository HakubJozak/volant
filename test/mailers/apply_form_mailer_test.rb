require 'test_helper'

class ApplyFormMailerTest < ActionMailer::TestCase
  test 'submitted' do
    form = Factory(:apply_form)
    tmpl = Factory(:email_template,action: 'submitted')

    mail = ApplyFormMailer.submitted(form)
    assert_equal 'multipart/mixed', mail.mime_type

    text = mail.body.parts.first.decoded
    assert_equal 'Body is not important', text
  end

  test 'submitted LTV' do
    form = Factory(:paid_ltv_form)
    tmpl = Factory(:email_template,action: 'ltv/submitted',body: 'LTV')

    mail = ApplyFormMailer.submitted(form)
    assert_equal 'multipart/mixed', mail.mime_type
    assert_equal 'LTV', mail.body.parts.first.decoded
  end
end
