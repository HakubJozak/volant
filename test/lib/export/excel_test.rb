require 'test_helper'

module Export
  class CsvTest < ActiveSupport::TestCase

    setup do
      @austria = countries(:AT)
      Factory.create(:apply_form)
      f = Factory.create(:paid_form)
      org = Factory.create(:organization,country: @austria,code: 'XYZ')
      f.current_workcamp.organization = org
      f.current_workcamp.save!
      f.save!
    end

    # TODO - test output
    test "#csv" do
      csv = Outgoing::ApplyForm.to_csv
      assert_equal csv.lines.count, 3
      assert_match /;Austria;/,csv
      assert_match /XYZ/,csv
    end
  end
end
