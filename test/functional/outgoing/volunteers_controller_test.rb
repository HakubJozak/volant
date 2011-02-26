require 'test_helper'

class Outgoing::VolunteersControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  protected

  def item
    Factory.create(:volunteer)
  end

end
