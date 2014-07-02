require 'test_helper'

module Incoming
  class ParticipantTest < ActiveSupport::TestCase
    setup do
      @participant = Factory.create(:participant)
    end

    test "create participant" do
      org = Factory.create(:organization)
      country = Factory.create(:country)
      form = Factory.create(:incoming_apply_form)
      p = Participant.new organization: org, gender: 'm', firstname: 'A', lastname: 'B', country: country, apply_form: form
      assert_valid p
    end

    test "have application after creation" do
      assert_not_nil @participant.apply_form, "Missing application"
      assert_not_nil @participant.apply_form.created_at
    end

    test "delegate some field calls to apply form" do
      [ :general_remarks, :motivation ].each do |attr|
        assert_equal nil, @participant.send(attr)
        @participant.send("#{attr.to_s}=", 'test')
        assert_equal 'test', @participant.send(attr)
      end
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
