require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test 'deliver!' do
    Mail::Message.any_instance.expects(:deliver).once

    message = Factory(:message)
    assert message.deliver!, 'Failed to deliver #{message.inspect}'
    first_sending = message.sent_at

    assert_not_nil first_sending
    assert message.sent?

    sleep(1) &&  message.deliver!
    assert_equal first_sending, message.sent_at, 'Message was sent twice'
  end

  test 'deliver! message with apply form' do
    apply_form = Factory(:paid_form)
    message = Factory(:message, apply_form: apply_form, action: 'accept')

    # before
    assert_equal :paid, apply_form.state.name

    Mail::Message.any_instance.expects(:deliver).once
    assert message.deliver!, 'Failed to deliver #{message.inspect}'

    # after sucesful send, the apply form state changes
    assert_equal :accepted, apply_form.state.name
  end

  test 'deliver! message with LTV apply form' do
    apply_form = Factory(:paid_ltv_form)
    message = Factory(:message, apply_form: apply_form, action: 'ltv/accept')

    # before
    assert_equal :paid, apply_form.state.name

    Mail::Message.any_instance.expects(:deliver).once
    assert message.deliver!, 'Failed to deliver #{message.inspect}'

    # after sucesful send, the apply form state changes
    assert_equal :accepted, apply_form.state.name
  end
  
end
