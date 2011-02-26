require 'test_helper'

class Incoming::BookingsControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  def setup
    super
    5.times { Factory.create(:booking) }
  end

  protected

  def item
    Factory.create(:booking)
  end

end
