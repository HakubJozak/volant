require 'test_helper'

module Incoming
  class ParticipantTest < ActiveSupport::TestCase

    context "Without Participant" do      
      should "be able to create participant" do
        attrs = { :gender => 'm', :firstname => 'A', :lastname => 'B' }
	p = Participant.new( attrs.merge(:organization => Factory.create(:organization)) )
        assert_valid p
      end
    end
    

    context "Participant" do
      setup do
	@participant = Factory.create(:participant)
      end

      should "have application after creation" do
        assert_not_nil @participant.apply_form, "Missing application"
        assert_not_nil @participant.apply_form.created_at
      end

      should "delegate some field calls to apply form" do
	[ :general_remarks, :motivation ].each do |attr|
          assert_equal nil, @participant.send(attr)
          @participant.send("#{attr.to_s}=", 'test')
          assert_equal 'test', @participant.send(attr)
        end	
      end

      should "be cancellable" do
	assert !@participant.cancelled?
        @participant.toggle_cancelled
        assert @participant.cancelled?
        @participant.toggle_cancelled
	assert !@participant.cancelled?
      end

    end
  end
end
