require 'test_helper'

class FreePlacesUpdaterTest < ActiveSupport::TestCase

  setup do
    @wc = Factory.create(:outgoing_workcamp, places: 2)
    @wc.workcamp_assignments.destroy_all

    @male = Factory.create(:male)
    @female = Factory.create(:female)
    
    @ma = Factory.create(:apply_form, volunteer: @male)
    @fa = Factory.create(:apply_form, volunteer: @female)
  end

  test "free places in empty workcamp with" do
    assert_equal 0, @wc.workcamp_assignments.size
    assert_equal 2, @wc.free_places
    assert_equal 2, @wc.free_places_for_females
    assert_equal 2, @wc.free_places_for_males
  end


  test "accepted" do
    male = @wc.workcamp_assignments.create(apply_form: @ma, order: 1)
    female = @wc.workcamp_assignments.create(apply_form: @fa, order: 1)

    male.reject(2.days.ago)
    female.accept
    assert_equal 1, @wc.reload.free_places

    male.accept
    assert_equal 0, @wc.reload.free_places
  end

  test "free_places_for_males" do
    male = @wc.workcamp_assignments.create(apply_form: @ma, order: 1)
    female = @wc.workcamp_assignments.create(apply_form: @fa, order: 1)

    @wc.places = 3
    @wc.places_for_males = 2
    @wc.places_for_females = 1
    @wc.save
    male.accept
    female.reject
    assert_equal 2, @wc.reload.free_places
    assert_equal 1, @wc.reload.free_places_for_males
    assert_equal 1, @wc.reload.free_places_for_females
  end

  test "free_places_for_females" do
    male = @wc.workcamp_assignments.create(apply_form: @ma, order: 1)
    female = @wc.workcamp_assignments.create(apply_form: @fa, order: 1)

    @wc.workcamp_assignments[1].accept
    assert_equal 1, @wc.reload.free_places_for_females
  end

  test "be careful with cancelled apply forms" do
    male = @wc.workcamp_assignments.create(apply_form: @ma, order: 1)
    female = @wc.workcamp_assignments.create(apply_form: @fa, order: 1)

    male.accept
    assert_equal 1, @wc.reload.free_places
    male.apply_form.cancel
    assert_equal 2, @wc.reload.free_places
  end

  test "correctly count asked_for places" do
    male = @wc.workcamp_assignments.create(apply_form: @ma, order: 1)
    female = @wc.workcamp_assignments.create(apply_form: @fa, order: 1)

    male.ask(1.day.ago)
    @wc.reload

    assert_equal 2, @wc.free_places
    assert_equal 1, @wc.asked_for_places
    assert_equal 1, @wc.asked_for_places_males
    assert_equal 0, @wc.asked_for_places_females
  end

  test 'incoming' do
    @wc.update_attribute(capacity: 6, capacity_males: 3, capacity_females: 3)
    form = Factory(:incoming_apply_form, volunteer: @male)
    male = @wc.workcamp_assignments.create(apply_form: form, order: 1)
    male.accept(1.day.ago)
    @wc.reload

    assert_equal 2, @wc.free_places
    assert_equal 5, @wc.free_capacity
    assert_equal 2, @wc.free_capacity_males
    assert_equal 3, @wc.free_capacity_females    
  end
end
