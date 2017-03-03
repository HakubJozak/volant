require 'test_helper'

class Incoming::HostingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: hostings
#
#  id          :integer          not null, primary key
#  workcamp_id :integer
#  partner_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#
