require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test 'send!' do
    Mail::Message.any_instance.expects(:deliver).once

    message = Factory(:message)
    assert message.deliver, 'Failed to deliver #{message.inspect}'
    first_sending = message.sent_at

    assert_not_nil first_sending
    assert message.sent?

    sleep(1) &&  message.deliver
    assert_equal first_sending, message.sent_at, 'Message was sent twice'
  end
end
