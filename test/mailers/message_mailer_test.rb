require 'test_helper'

class MessageMailerTest < ActiveSupport::TestCase
  test 'standard_email' do
    message = Factory(:message)
    mail = MessageMailer.standard_email(message)
    assert_equal mail.mime_type, 'text/html'
  end
end
