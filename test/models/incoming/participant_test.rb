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
  end
end
