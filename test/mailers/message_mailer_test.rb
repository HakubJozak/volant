require 'test_helper'

class MessageMailerTest < ActiveSupport::TestCase
  test 'standard_email' do
    message = Factory(:message, html_body: '<b>Sending HTML content.</b>')
    mail = MessageMailer.standard_email(message)
    assert_equal mail.mime_type, 'text/html'
    assert_equal mail.body, '<b>Sending HTML content.</b>'
  end
end
