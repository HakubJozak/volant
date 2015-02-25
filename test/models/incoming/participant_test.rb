require 'test_helper'

module Incoming
  class ParticipantTest < ActiveSupport::TestCase
    setup do
      @participant = Factory.create(:participant)
      @org = Factory.create(:organization)
      @form = Factory.create(:incoming_apply_form)
    end

    test "create participant" do
      p = Participant.new( organization: @org,
                           gender: 'm',
                           firstname: 'A',
                           lastname: 'B',
                           country: @org.country,
                           apply_form: @form,
                           email: 'some@there.com')
      assert_valid p
    end

    test "have application after creation" do
      assert_not_nil @participant.apply_form, "Missing application"
      assert_not_nil @participant.apply_form.created_at
    end

    test "delegate some field calls to apply form" do
      @participant.apply_form.general_remarks = 'OJOJ!'
      assert_equal 'OJOJ!', @participant.general_remarks

      @participant.apply_form.motivation = 'TOMA!'
      assert_equal 'TOMA!', @participant.motivation
    end

    test "be cancellable" do
	assert !@participant.cancelled?
        @participant.toggle_cancelled
        assert @participant.cancelled?
        @participant.toggle_cancelled
	assert !@participant.cancelled?
      end
  end
end
