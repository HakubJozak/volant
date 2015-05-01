require 'test_helper'

module Export
  class FridayListTest < ActiveSupport::TestCase

    test "Workcamp::friday_list" do
      Workcamp.destroy_all
      Factory(:incoming_workcamp, name: 'Aaargh',code: 'AAA')
      Factory(:incoming_workcamp, name: 'Zzzzzz')

      csv = Export::FridayList.new(Incoming::Workcamp.order(:name)).to_csv
      assert_equal 3,csv.lines.count

      row = CSV.new(csv,col_sep: ';',headers: true).first
      assert_equal 'Aaargh', row['Name']
      assert_equal 'AAA', row['Code']      
    end
  end
end
