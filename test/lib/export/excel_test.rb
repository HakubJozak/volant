require 'test_helper'

module Export
  class ExcelTest < ActiveSupport::TestCase

    setup do
      @austria = countries(:AT)
    end

    test "ApplyForm::to_csv" do
      Factory.create(:apply_form, firstname: 'XXX', lastname: 'YYY')
      f = Factory.create(:paid_form)
      org = Factory.create(:organization,country: @austria,code: 'XYZ')
      f.current_workcamp.organization = org
      f.current_workcamp.save!
      f.save!

      csv = Outgoing::ApplyForm.to_csv
      assert_equal csv.lines.count, 3
      assert_match /;Austria;/,csv
      assert_match /XYZ/,csv
      assert_match /XXX/, csv
      assert_match /YYY/, csv

      # TODO
      # require 'csv'
      # parsed = CSV.parse(csv)
      # puts parsed.inspect
    end


    test "Workcamp::to_csv" do
      Workcamp.destroy_all
      Factory(:outgoing_workcamp)
      Factory(:incoming_workcamp)

      csv = Workcamp.to_csv
      assert_equal 3,csv.lines.count
    end
  end
end
