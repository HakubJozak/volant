require 'test_helper'

class NetworkTest < ActiveSupport::TestCase

  def setup
    @seeds = organizations(:seeds)
  end

  test "Seeds belongs to one network" do
    assert_equal 1, @seeds.networks.size
  end
end
