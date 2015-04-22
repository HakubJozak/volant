require 'test_helper'

module Outgoing
  class WorkcampAssignmentTest < ActiveSupport::TestCase

    def setup
      Factory.create(:workcamp_assignment)
    end

    test "state change" do
      wa = Factory.create(:workcamp_assignment)
      wa.ask
    end

    test "caching" do
      form = Factory.create(:apply_form)
      a = Factory.create(:workcamp_assignment, :apply_form_id => form.id, :accepted => Time.now)

      assert form.reload.is?(:accepted), "ApplyForm is supposed to be accepted now"

      a.accepted = nil
      a.rejected = Time.now
      a.save
      assert form.reload.is?(:rejected), "ApplyForm is supposed to be rejected now"
    end
  end
end
