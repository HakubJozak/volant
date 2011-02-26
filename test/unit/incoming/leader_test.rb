require 'test_helper'

module Incoming
  class LeaderTest < ActiveSupport::TestCase
    context "Leader" do
      setup do
        5.times { Factory.create(:leader) }
      end

      should "list all leaderships" do
        assert_not_nil Leader.first.leaderships
      end
    end
  end
end
