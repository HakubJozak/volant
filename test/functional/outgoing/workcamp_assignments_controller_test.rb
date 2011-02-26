require 'test_helper'

module Outgoing
  class WorkcampAssignmentsControllerTest < ActionController::TestCase

    include ActiveScaffoldCRUDTester

    protected

    def item
      Factory.create(:workcamp_assignment)
    end

  end
end
