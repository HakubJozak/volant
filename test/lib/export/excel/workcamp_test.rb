require 'test_helper'

class Export::Excel::WorkcampTest < ActiveSupport::TestCase

  test "Workcamp::to_csv" do
    ::Workcamp.destroy_all
    Factory(:outgoing_workcamp)
    Factory(:incoming_workcamp)

    csv = Export::Excel::Workcamp.new(Workcamp).to_csv
    assert_equal 3,csv.lines.count
  end
end

