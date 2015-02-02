require 'test_helper'

module Export
  class CsvTest < ActiveSupport::TestCase

      setup do
        Factory.create(:apply_form)
        o = Factory.create(:organization)
        f = Factory.create(:paid_form)
        f.current_workcamp.organization = o
        f.current_workcamp.save!
        f.save!
      end

      # TODO - test output
      should "produce valid CSV" do
      csv = Outgoing::ApplyForm.to_csv
      assert_equal csv.lines.count, 3
      end
  end
end
