require 'test_helper'

class Incoming::WorkcampsAndPartnersControllerTest < ActionController::TestCase

    include ActiveScaffoldCRUDTester

    protected

    def item
      Factory.create(:incoming_workcamp)
    end

end
