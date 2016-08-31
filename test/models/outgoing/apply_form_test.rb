require 'test_helper'

module Outgoing
  class ApplyFormTest < ActiveSupport::TestCase

    def setup
      DataLoader.load_emails
    end

    test "rejection" do
      rejected = create(:rejected_form)
      assert rejected.rejected?, "The application should be rejected"
    end

    test "payments" do
      a = create(:paid_form)
      assert_state a, :paid

      a.payment.amount -= 200
      assert a.is?(:not_paid)
    end

    test "current_assignment" do
      form = create(:accepted_form)
      assert_not_nil form.current_assignment
      assert_not_nil form.current_workcamp
    end

    test "asking and acceptation" do
      form = create(:paid_form)
      assert form.is?(:paid), "Form should be paid"
      assert form.ask.is?(:asked), "Form should be asked"
      assert form.accept.is?(:accepted), "Form should be accepted"
    end

    test "assignment rejection" do
      @paid = create(:paid_form)
      @paid.workcamps.clear
      ::Workcamp.limit(3).each_with_index do |wc,i|
        @paid.workcamp_assignments << Outgoing::WorkcampAssignment.new(workcamp: wc)
      end

      @paid.reload
      assert @paid.ask.is?(:asked)
      assert @paid.reject.is?(:paid), @paid.state.name
      assert @paid.reject.is?(:paid), @paid.state
      assert @paid.reject.is?(:rejected), @paid.state
    end

    test "state labelling" do
      state = create(:rejected_form).state
      assert_equal :rejected, state.name
    end

    test "destroy" do
      form = create(:paid_form)
      payment_id = form.payment.id
      volunteer_id = form.volunteer.id
      id = form.id

      form.destroy

      assert_nil ApplyForm.find_by_id(id)
      assert_not_nil Payment.find(payment_id)
      assert_not_nil Volunteer.find(volunteer_id)
    end

    test "workcamp list" do
      @f = create(:paid_form)
      @f.workcamp_assignments.delete_all
      5.times { |i| create(:workcamp_assignment, apply_form: @f) }
      @f.reload
      assert_equal 5, @f.workcamps.size
      assert_not_empty @f.workcamps_list
    end

    protected

    def assert_state(form, state)
      assert form.is?(state), "#{form} is not in state '#{state.to_s}'"
    end

  end
end
