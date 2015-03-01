require 'test_helper'


module Outgoing
  class WorkcampTest < ActiveSupport::TestCase
    context "Outgoing::Workcamp" do
      setup do
        @wc = Factory.create(:outgoing_workcamp, :begin => 1.day.from_now, :end => 10.days.from_now)
      end

      context "just exists" do
        setup do
          Outgoing::Workcamp::destroy_all
          @kytlice = Factory.create(:outgoing_workcamp, :name => 'Kytlice')
          @xaverov = Factory.create(:outgoing_workcamp, :code => 'XWE')
        end

        should "approximate search by name" do
          assert_equal @kytlice, Outgoing::Workcamp.find_by_name_or_code('kytl')[0]
        end

        should "approximate search by code" do
          assert_equal @xaverov, Outgoing::Workcamp.find_by_name_or_code('xwe')[0]
        end
     end
    end
  end
end
