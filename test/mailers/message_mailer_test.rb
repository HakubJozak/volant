require 'test_helper'

class MessageMailerTest < ActiveSupport::TestCase
  test 'standard_email' do
    message = Factory(:message, html_body: '<b>Sending HTML content.</b>',
                      to: 'you@gmail.com, other@example.com',
                      from: 'me@gmail.com',
                      bcc: 'secret@address.com')
    mail = MessageMailer.standard_email(message)

    assert_equal  'text/html',mail.mime_type
    assert_equal  '<b>Sending HTML content.</b>',mail.body.to_s
    assert_equal  ['you@gmail.com','other@example.com'],mail.to
    assert_equal 'secret@address.com', mail.bcc.first
    assert_equal 'me@gmail.com', mail.from.first
  end
end
