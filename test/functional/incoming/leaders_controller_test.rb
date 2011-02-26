require 'test_helper'

class Incoming::LeadersControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  def setup
    super
    5.times { Factory.create(:leader) }
  end

  protected

  def item
    Factory.create(:leader)
  end
end
