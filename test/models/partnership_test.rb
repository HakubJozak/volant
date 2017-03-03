require 'test_helper'

class PartnershipTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: partnerships
#
#  id              :integer          not null, primary key
#  description     :string(255)
#  network_id      :integer
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#
