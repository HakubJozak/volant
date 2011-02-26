require 'test_helper'

module Incoming
  class LeadershipsControllerTest < ActionController::TestCase

    include ActiveScaffoldCRUDTester

    protected

    def item
      Leadership.create!( :leader => Factory.create(:leader), :workcamp => Factory.create(:incoming_workcamp))
    end

  end
end
