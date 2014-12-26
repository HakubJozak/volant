require 'test_helper'


# TODO - move import tests to different file
module Outgoing
  class WorkcampTest < ActiveSupport::TestCase
    context "Outgoing::Workcamp" do
      setup do
        @wc = Factory.create(:outgoing_workcamp, :begin => 1.day.from_now, :end => 10.days.from_now)
      end

      should "recognize almost full workcamp" do
        @wc.workcamp_assignments.destroy_all
        @wc.places = 2
        @wc.places_for_males = 1
        @wc.places_for_females = 1
        @wc.save

        male = Factory.build(:male)
        female = Factory.build(:female)
        assert_equal false, @wc.reload.almost_full?(male)
        assert_equal false, @wc.reload.full?(male)

        mwa = Factory.create(:workcamp_assignment, :workcamp => @wc, :apply_form => Factory.create(:form_male))
        fwa = Factory.create(:workcamp_assignment, :workcamp => @wc, :apply_form => Factory.create(:form_female))
        mwa.accept
        fwa.ask

        assert @wc.reload.almost_full?(male), "Workcamp is not almost full"
        assert @wc.reload.full?(male), "Workcamp is not full"
        assert @wc.reload.almost_full?(female), "Workcamp is not almost full"
        assert !@wc.reload.full?(female), "Workcamp shouldn't be full for women"
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

      context "with imported" do
        setup do
          Outgoing::Workcamp::destroy_all
          @imported = Factory.create(:outgoing_workcamp, :state => 'imported')
          @updated = Factory.create(:outgoing_workcamp, :state => 'updated')
          @normal = Factory.create(:outgoing_workcamp)
          @updated.import_changes.create(:field => 'name', :value => 'COOL!')
        end

        should 'import_all!' do
          Outgoing::Workcamp.import_all!
          assert_equal 3, Outgoing::Workcamp.count
          assert Outgoing::Workcamp.all.all? { |wc| wc.state == nil }

          @updated.reload
          assert_equal 0, @updated.import_changes.size
          assert_equal @updated.name, 'COOL!'
        end

        should 'cancel_import!' do
          assert_equal 3, Outgoing::Workcamp.count
          assert_equal 2, Outgoing::Workcamp.imported_or_updated.count
          Outgoing::Workcamp.cancel_import!
          assert_equal 0, Outgoing::Workcamp.imported_or_updated.count
          assert_equal 2, Outgoing::Workcamp.count

          @updated.reload
          assert_equal 0, @updated.import_changes(true).size
          assert_equal false,  @updated.updated?
        end
      end

    end
  end
end
