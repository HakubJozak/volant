require 'test_helper'

class ApplyFormStateTest < ActiveSupport::TestCase

  def setup
    @t = Time.now
    @form = Factory.create(:paid_form)
    @form.volunteer = Factory.create(:female)

    @asked = ApplyFormState.new(:asked,@t, @form)
    @accepted = ApplyFormState.new(:accepted,@t, @form)
  end

  test "actions" do
    assert_equal @accepted.actions, [ :infosheet ]
    assert_equal @asked.actions, [ :accept, :reject ]
  end

  test "create cancelled state" do
    assert_equal :cancelled, @form.cancel.state.name
  end

  test "create paid state" do
    assert_equal :paid, @form.state.name
  end
end
