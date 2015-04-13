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

  test 'deliver! with workcamp' do
    wc = Factory(:incoming_workcamp)
    form = Factory(:incoming_apply_form)
    form.assign_workcamp(wc)
    form.accept

    dummy = Factory(:incoming_apply_form)
    dummy.assign_workcamp(wc)
    dummy.assign_workcamp(w2 = Factory(:incoming_workcamp))
    dummy.reject
    dummy.accept

    dummy2 = Factory(:incoming_apply_form)
    dummy2.assign_workcamp(wc)

    Mail::Message.any_instance.expects(:deliver).once
    Factory(:message, workcamp: wc, action: 'infosheet_all').deliver!

    assert_equal :infosheeted, form.state.name
    assert_equal :accepted, dummy.state.name    
    assert_equal :paid, dummy2.state.name
  end

  test 'deliver! with apply form' do
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
    message = Factory(:message, apply_form: apply_form, action: 'accept')

    # before
    assert_equal :paid, apply_form.state.name

    Mail::Message.any_instance.expects(:deliver).once
    assert message.deliver!, 'Failed to deliver #{message.inspect}'

    # after sucesful send, the apply form state changes
    assert_equal :accepted, apply_form.state.name
  end

end
