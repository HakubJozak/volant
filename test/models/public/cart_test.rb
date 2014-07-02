require 'test_helper'


class Public::CartTest < ActiveSupport::TestCase

  def setup
    @workcamps = Workcamp.limit(10)
    @cart = Public::Cart.new
  end

  def test_non_existent_workcamp
    @cart.add_workcamp(-458)
    assert_equal [], @cart.workcamps
  end

  def test_workcamp_handling
    assert_equal false, @cart.contains?(@first)

    # add all items
    @workcamps.each_with_index do |item,i|
      @cart.add_workcamp(item)
      assert @cart.contains?(item), "Added workcamp not in cart."
      assert_equal (i + 1), @cart.size
    end

    # check also order
    assert_equal @workcamps, @cart.workcamps

    @cart.empty!
    assert_cart_contains_nothing
  end

  def test_contains?
    @cart.add_workcamp @workcamps.first
    assert @cart.contains?(@workcamps.first)
  end

  def test_just_changed
    @cart.add_workcamp @workcamps.first
    assert_equal @workcamps.first, @cart.just_changed.first
  end

  def test_workcamps_ids
    @cart.add_workcamp @workcamps.first
    assert_equal [ @workcamps.first.id ], @cart.workcamps_ids
  end

  private

  def assert_cart_contains_nothing
    assert_equal 0, @cart.size
    @workcamps.each do |item|
      assert_equal false, @cart.contains?(item)
    end
  end


end
