require 'test_helper'

module Export
  class FridayListTest < ActiveSupport::TestCase

    test "Workcamp::friday_list" do
      Workcamp.destroy_all
      Factory(:incoming_workcamp)
      Factory(:incoming_workcamp)      

      csv = Incoming::Workcamp.friday_list
      assert_equal 3,csv.lines.count
      puts csv
    end
  end
end
