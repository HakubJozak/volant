require 'test_helper'

class NetworkTest < ActiveSupport::TestCase

  def setup
    @seeds = organizations(:seeds)
  end

  test "Seeds belongs to one network" do
    assert_equal 1, @seeds.networks.size
  end
end

# == Schema Information
#
# Table name: networks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  web        :string(255)
#  created_at :datetime
#  updated_at :datetime
#
