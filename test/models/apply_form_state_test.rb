require 'test_helper'

class ApplyFormStateTest < ActiveSupport::TestCase

  def setup
    @form = Factory.create(:paid_form)
    @form.volunteer = Factory.create(:female)

    @asked = ApplyFormState.new(:asked,Time.now, @form)
    @accepted = ApplyFormState.new(:accepted,Time.now, @form)
    @paid = ApplyFormState.new(:paid,Time.now, @form)
    @infosheeted = ApplyFormState.new(:infosheeted,Time.now, @form)
    @confirmed = ApplyFormState.new(:confirmed,Time.now, @form)    
  end

  test "actions" do
    assert_equal [ :ask, :accept, :reject, :cancel ], @paid.actions
    assert_equal [ :accept, :reject, :cancel ], @asked.actions
    assert_equal [ :infosheet, :confirm, :cancel ], @accepted.actions
    assert_equal [ :confirm, :cancel ], @infosheeted.actions
    assert_equal [ :cancel ], @confirmed.actions    
  end

  test "create confirmed" do
    wa = @form.current_assignment
    wa.confirm(1.day.ago)
    assert_equal :confirmed, @form.reload.state.name    
  end

  test "create cancelled state" do
    assert_equal :cancelled, @form.cancel.state.name
  end

  test "create paid state" do
    assert_equal :paid, @form.state.name
  end
end
