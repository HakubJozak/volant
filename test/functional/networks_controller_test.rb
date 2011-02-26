require 'test_helper'

class NetworksControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  protected

  def item
    Network.find(:first)
  end

end
