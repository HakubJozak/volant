require 'test_helper'

module Outgoing
  class ApplyFormTest < ActiveSupport::TestCase

    def setup
      DataLoader.load_emails
    end

    test "rejection" do
      rejected = Factory.create(:rejected_form)
      assert rejected.rejected?, "The application should be rejected"
    end

    test "payments" do
      a = Factory.create(:paid_form)
      assert_state a, :paid

      a.payment.amount -= 200
      assert a.is?(:not_paid)
    end

    # TODO - test and implement fee calculation
    test "creation of new apply form" do
      a = ApplyForm.new(:volunteer => Factory.create(:male))
      a.save!
      b = ApplyForm.find(a.id)
      assert_equal a, b
    end

    test "current assignment" do
      form = Factory.create(:accepted_form)
      assert_not_nil form.current_assignment
      assert_not_nil form.current_workcamp
    end

    test "asking and acceptation" do
      form = Factory.create(:paid_form)
      assert form.is?(:paid), "Form should be paid"
      assert form.ask.is?(:asked), "Form should be asked"
      assert form.accept.is?(:accepted), "Form should be accepted"
    end

    test "assignment rejection" do
      @paid = Factory.create(:paid_form)
      @paid.workcamps.clear
      Workcamp.find(:all, :limit => 3).each_with_index do |wc,i|
        @paid.workcamp_assignments << Outgoing::WorkcampAssignment.new( :order => i+1, :workcamp => wc )
      end

      @paid.reload
      assert @paid.ask.is?(:asked)
      assert @paid.reject.is?(:paid)
      assert @paid.reject.is?(:paid)
      assert @paid.reject.is?(:rejected)
    end

    test "cancelled time parsing" do
      form = Factory.create(:paid_form)
      form.cancelled_string = "22.1.2009 15:50"
      assert_equal DateTime.new(2009,1,22,15,50), form.cancelled
    end


    test "state labelling" do
      state = Factory.create(:rejected_form).state
      assert_equal :rejected, state.name
    end

    test "destroy apply form with payment" do
      form = Factory.create(:paid_form)

      assert_not_nil form.payment
      assert_nothing_raised do
        id = form.id
        form.destroy
        assert_nil ApplyForm.find_by_id(id)
      end
    end

    # test "conversion to CSV" do
    #   I18n.locale = 'cs'
    #   volunteer = Factory.create(:female, :firstname => 'Hana', :lastname => 'Hozakova')
    #   data_line = Factory.create(:accepted_form, :volunteer => volunteer).to_csv
    #   header_line = ApplyForm::CSV_HEADER

    #   headers = header_line.split(",")
    #   data = data_line.split(",")

    #   hashed = Hash.new
    #   headers.each_index do |i|
    #     hashed[headers[i]] = (data[i] || '').tr('"',"")
    #   end

    #   assert_equal hashed['firstname'], 'Hana'
    #   assert_equal hashed['lastname'], 'Hozakova'
    #   assert_equal hashed['fee'], '2200.0'
    #   assert_equal hashed['city'], 'Praha'
    #   assert_equal hashed['occupation'], 'Programator'
    #   assert_equal hashed['birthdate'], '1982-03-27'
    # end

    test "workcamp list" do
      @f = Factory.create(:paid_form)
      @f.workcamp_assignments.delete_all
      5.times { |i| Factory.create(:workcamp_assignment, :order => i, :apply_form => @f) }
      @f.reload
      assert_equal 5, @f.workcamps.size
      puts @f.workcamps_list
    end

    protected

    def assert_state(form, state)
      assert form.is?(:paid), "#{form} is not in state '#{state.to_s}'"
    end

  end
end
