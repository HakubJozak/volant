require 'test_helper'

class TagsControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  protected

  def item
    Tag.find(:first)
  end

end
