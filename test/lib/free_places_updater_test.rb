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
    male = @wc.workcamp_assignments.create(apply_form: @ma)
    female = @wc.workcamp_assignments.create(apply_form: @fa)

    male.reject(2.days.ago)
    female.accept
    assert_equal 1, @wc.reload.free_places

    male.accept
    assert_equal 0, @wc.reload.free_places
  end

  test "free_places_for_males" do
    male = @wc.workcamp_assignments.create(apply_form: @ma)
    female = @wc.workcamp_assignments.create(apply_form: @fa)

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
    male = @wc.workcamp_assignments.create(apply_form: @ma)
    female = @wc.workcamp_assignments.create(apply_form: @fa)

    @wc.workcamp_assignments[1].accept
    assert_equal 1, @wc.reload.free_places_for_females
  end

  test "be careful with cancelled apply forms" do
    male = @wc.workcamp_assignments.create(apply_form: @ma)
    female = @wc.workcamp_assignments.create(apply_form: @fa)

    male.accept
    assert_equal 1, @wc.reload.free_places
    male.apply_form.cancel
    assert_equal 2, @wc.reload.free_places
  end

  test "correctly count asked_for places" do
    male = @wc.workcamp_assignments.create(apply_form: @ma)
    female = @wc.workcamp_assignments.create(apply_form: @fa)

    male.ask(1.day.ago)
    @wc.reload

    assert_equal 2, @wc.free_places
    assert_equal 1, @wc.asked_for_places
    assert_equal 1, @wc.asked_for_places_males
    assert_equal 0, @wc.asked_for_places_females
  end

  test 'incoming' do
    @wc.update_attributes(capacity: 6, capacity_males: 4, capacity_females: 2)
    assign_and_accept(@wc,:incoming_female_form)
    assign_and_accept(@wc,:incoming_male_form)
    @wc.bookings.create! country: Factory(:country),gender: 'm'

    @wc.reload

    binding.pry

    assert_equal 2, @wc.free_places
    assert_equal 6, @wc.capacity
    assert_equal 3, @wc.free_capacity
    assert_equal 2, @wc.free_capacity_males
    assert_equal 1, @wc.free_capacity_females
  end

  test 'incoming and outgoing' do
    @wc.update_attributes(capacity: 8, capacity_males: 3, capacity_females: 5, places: 3)
    2.times { assign_and_accept(@wc,:incoming_female_form) }
    assign_and_accept(@wc,:incoming_male_form)
    assign_and_accept(@wc,:form_male)
    assign_and_accept(@wc,:form_female)

    @wc.reload

    assert_equal 1, @wc.free_places
    assert_equal 1, @wc.free_places_for_males
    assert_equal 1, @wc.free_places_for_females        

    assert_equal 3, @wc.free_capacity
    assert_equal 1, @wc.free_capacity_males
    assert_equal 2, @wc.free_capacity_females
  end

  private

  def assign_and_accept(wc,type)
    wc.workcamp_assignments.create!(apply_form: Factory(type)).accept(1.day.ago)
  end

  def booking(wc,opts)

  end
end
