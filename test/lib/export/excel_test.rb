require 'test_helper'

module Export
  class CsvTest < ActiveSupport::TestCase

    setup do
      @austria = countries(:AT)
    end

    test "#csv" do
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
  end
end
