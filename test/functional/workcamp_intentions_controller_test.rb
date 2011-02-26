require 'test_helper'

class WorkcampIntentionsControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  protected

  def item
    WorkcampIntention.find(:first)
  end

end
