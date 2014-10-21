require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test 'send!' do
    m = Factory(:message)
    m.send!
    assert sent?
    assert_not_nil m.sent_at
  end
end
