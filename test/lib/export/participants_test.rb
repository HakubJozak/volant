require 'test_helper'

module Export
  class ParticipantsTest < ActiveSupport::TestCase

    test '#to_csv' do
      wc = Factory(:incoming_workcamp, name: 'Aaargh')
      assign_and_accept(wc)
      assign_and_accept(wc)
      assign_and_accept(wc)
      assign_and_accept(wc)

      csv = Export::Participants.new(wc.apply_forms.accepted).to_csv
      assert_equal 5,csv.lines.count
      puts csv
      # TODO: row = parsed(csv).first
    end

    private

    def parsed(csv)
      CSV.new(csv,col_sep: ';',headers: true, converters: :all)
    end

    def assign_and_accept(wc)
      f = Factory(:incoming_apply_form)
      wc.workcamp_assignments.create!(apply_form: f)
      f.reload.accept(1.day.ago)
    end
  end
end
