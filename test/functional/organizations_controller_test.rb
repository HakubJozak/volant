require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  protected

  def item
    Organization.find(:first)
  end

end
