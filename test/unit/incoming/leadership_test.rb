require 'test_helper'

module Incoming
  class LeadershipTest < ActiveSupport::TestCase
    context "Leadership" do
      should "be created" do
        assert_not_nil Leadership.create
      end
    end
  end
end
