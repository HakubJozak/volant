require 'test_helper'

class FreePlacesObserverTest < ActiveSupport::TestCase
  context "FreePlacesObserver" do
    setup do
      @wc = Factory.create(:outgoing_workcamp)
      @wc.workcamp_assignments.destroy_all
    end

    should "correctly count free places in empty workcamp with" do
      assert_equal 0, @wc.workcamp_assignments.size
      assert_equal 2, @wc.free_places
    end

    context "with assignments" do
      setup do
        ma = Factory.create(:apply_form, :volunteer => Factory.create(:male))
        fa = Factory.create(:apply_form, :volunteer => Factory.create(:female)) 
	@male = @wc.workcamp_assignments.create(:apply_form => ma, :order => 1)
	@female = @wc.workcamp_assignments.create(:apply_form => fa, :order => 1)
      end

      should "correctly count accepted" do
        @male.reject(2.days.ago)
        @female.accept
        assert_equal 1, @wc.reload.free_places

        @male.accept
        assert_equal 0, @wc.reload.free_places
      end

      should "correctly count males" do
        @wc.places = 3
        @wc.places_for_males = 2
        @wc.places_for_females = 1
        @wc.save
        @male.accept
        @female.reject
        assert_equal 2, @wc.reload.free_places
        assert_equal 1, @wc.reload.free_places_for_males
        assert_equal 1, @wc.reload.free_places_for_females
      end

      should "correctly count females" do
        @wc.workcamp_assignments[1].accept
        assert_equal 1, @wc.reload.free_places_for_females
      end

      should "be careful with cancelled apply forms" do
        @male.accept
        assert_equal 1, @wc.reload.free_places
        @male.apply_form.cancel
        assert_equal 2, @wc.reload.free_places
      end

      should "correctly count asked_for places" do
        @male.ask(1.day.ago)
        @wc.reload
        assert_equal 2, @wc.free_places
        assert_equal 1, @wc.asked_for_places
        assert_equal 1, @wc.asked_for_places_males
        assert_equal 0, @wc.asked_for_places_females
      end
      
    end

  end

end
