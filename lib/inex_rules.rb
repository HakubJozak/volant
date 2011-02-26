module InexRules

  def self.organization_response_limit
    4.day.ago.to_date
  end

  # the latest time before workcamp start
  def self.infosheet_waiting_limit
    1.month.from_now.to_date
  end

  # Recalculates number of places available to INEX volunteers in supplied Workcamp.
  # Used while importing new workcamps from the Alliance database.
  def compute_places(wc)
    if wc.capacity == nil or wc.capacity > 7
      wc.places = 2
    else
      wc.places = 1
    end

    wc.places_for_females = [ wc.places, wc.capacity_females ].compact.min
    wc.places_for_males = [ wc.places, wc.capacity_males ].compact.min
  end
end
