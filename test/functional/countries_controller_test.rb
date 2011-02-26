require 'test_helper'

class CountriesControllerTest < ActionController::TestCase

  include ActiveScaffoldReadOnlyTester

  protected

  def item
    Factory.create(:czech_republic)
  end
end
