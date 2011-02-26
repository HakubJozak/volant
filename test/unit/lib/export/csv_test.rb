require 'test/test_helper'

module Export
  class CsvTest < ActiveSupport::TestCase
    context "CSV Export" do
      setup do
        Factory.create(:paid_form)
        o = Factory.create(:organization)
        f = Factory.create(:paid_form)        
        f.current_workcamp.organization = o
        f.current_workcamp.save!
        f.save!
      end

      # TODO - test output
      should "produce valid CSV" do
        assert_not_nil Export::Csv::outgoing_apply_forms
        assert_not_nil Export::Csv::outgoing_apply_forms(:year => '2010')
      end
    end
  end
end
