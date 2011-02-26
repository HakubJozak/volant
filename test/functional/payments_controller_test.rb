require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase

  include ActiveScaffoldCRUDTester

  protected

  def item
    Payment.find(:first)
  end

end
