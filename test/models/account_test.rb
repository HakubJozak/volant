require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: accounts
#
#  id                          :integer          not null, primary key
#  organization_id             :integer          not null
#  season_end                  :date             default(Sun, 15 Mar 2015), not null
#  organization_response_limit :integer          default(4), not null
#  infosheet_waiting_limit     :integer          default(30), not null
#  created_at                  :datetime
#  updated_at                  :datetime
#
