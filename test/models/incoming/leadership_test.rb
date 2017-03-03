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

# == Schema Information
#
# Table name: leaderships
#
#  id          :integer          not null, primary key
#  person_id   :integer
#  workcamp_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#
