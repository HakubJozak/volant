require 'test_helper'

module Export
  class FridayListTest < ActiveSupport::TestCase

    test "Workcamp::friday_list" do
      Workcamp.destroy_all
      Factory(:incoming_workcamp, name: 'Zzzzzz')
      wc = Factory(:incoming_workcamp, name: 'Aaargh',code: 'AAA', capacity: 10)
      wc.update_columns(free_capacity: 3, free_capacity_males: -1, free_capacity_females: 3)

      csv = Export::FridayList.new(Incoming::Workcamp.order(name: :asc)).to_csv
      assert_equal 3,csv.lines.count

      row = parsed(csv).first
      assert_equal 'Aaargh', row['Name']
      assert_equal 'AAA', row['Code']
      assert_equal 10, row['Capacity']
      assert_equal 3, row['Free capacity']
      assert_equal 0, row['Free capacity males']
      assert_equal 3, row['Free capacity females']
    end

    test 'no more' do
      Workcamp.destroy_all
      france = Factory(:country, name_en: 'France')
      germany = Factory(:country, name_en: 'Germany')
      
      wc = Factory(:incoming_workcamp, name: 'Aaargh',code: 'AAA', capacity: 10)
      assign_and_accept(wc,france)
      assign_and_accept(wc,france)

      # regression test for
      # http://redmine.siven.onesim.net/issues/1550
      assign_and_accept(wc,nil,:apply_form)
      assign_and_accept(wc,nil,:apply_form)      

      assign_and_accept(wc,germany)
      assign_and_accept(wc,germany)
      
      csv = Export::FridayList.new(Incoming::Workcamp.order(name: :asc)).to_csv
      assert_equal 2,csv.lines.count

      row = parsed(csv).first
      assert_equal ['France','Germany'], row['No more'].split(',').sort
    end

    private

    def parsed(csv)
      CSV.new(csv,col_sep: ';',headers: true, converters: :all)
    end

    def assign_and_accept(wc,country,type = :incoming_apply_form)
      f = Factory(type,country: country)
      wc.workcamp_assignments.create!(apply_form: f)
      f.reload.accept(1.day.ago)
    end
  end
end
