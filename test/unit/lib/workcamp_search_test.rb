require 'test/test_helper'

class WorkcampSearchTest < ActiveSupport::TestCase
  context "With many workcamps" do
    setup do
      Workcamp.destroy_all

      100.times do |i|
        Factory.create(:workcamp, :begin => 1.day.from_now, :end => 10.days.from_now)
      end
    end

    should "list all workcamps" do
      puts Workcamp.count
      assert_equal 15, WorkcampSearch::find_by_query({}).size
      assert_equal 100, WorkcampSearch::total({})
    end

    should "list free only" do
      assert_list_by_query({ :free_only => '1' }) do |wc|
        assert wc.free_places > 0, "There are just #{wc.free_places} places"
      end
    end
  end

  context "With only one workcamp" do
    setup do
      Workcamp.destroy_all
      @new = Factory.create(:workcamp, :begin => 1.day.from_now, :end => 3.days.from_now)
      @czechia = Country.find_by_code('CZ')
      @edu = WorkcampIntention.find_by_code('EDU')
      @envi = WorkcampIntention.find_by_code('ENVI')
    end

    should "ussual workcamp query" do
      # at least this workcamp should be found
      @new.country = Country.first
      @new.begin = 10.days.from_now
      @new.airport = 'Ruzyne'
      @new.save!

      ussual = { :countries => [ @new.country.code ], :from => Date.today }
      assert_list_by_query(ussual) do |wc|
        assert_equal @new.country.code, wc.country.code
        assert_equal 'Ruzyne', wc.airport
        assert wc.begin >= Date.today
      end
    end


    should "find by intentions" do
      @new.intentions << @edu
      @new.save!

      assert_list_by_query({ :intentions => [ @edu.id ] }) do |wc|
        assert wc.intentions.include?(@edu), "#{wc.intentions} are not right"
      end
    end

    should "query workcamps by suitable age" do
      @new.minimal_age = 22
      @new.maximal_age = 77
      @new.save!

      [ 55, 67 ].each do |age|
        assert_list_by_query({ :age => age}) do |wc|
          assert wc.accepts_age?(age)
        end
      end
    end
  end

  private

  # Runs the query, checks the result is non-empty and runs block for every found workcamp
  def assert_list_by_query(query)
    workcamps = WorkcampSearch.find_by_query(query)
    assert_not_empty workcamps
    workcamps.each do |wc|
      yield(wc)
    end
  end

end
