module Outgoing::FreePlacesUpdater
  extend ActiveSupport::Concern

  def update_free_places
    if self.respond_to?(:workcamps)
      self.workcamps.reload.each { |wc| wc.save! }
    elsif self.respond_to?(:workcamp)
      self.workcamp.save!
    else
      raise "Cannot update free places. #{self.inspect} has no workcamp(s) association."
    end
  end

  # In fact, updates accepted_* and asked_for_* attributes so that free_places_* are computed correctly.
  def update_free_places_for_workcamp(wc = self)
    kinds = [ [ "", :id ],
              [ "_males", :male? ],
              [ "_females", :female? ] ]

    kinds.each do |sufix, condition|
      asked = accepted = 0

      wc.workcamp_assignments.each do |wa|
        a = wa.apply_form

        if a.volunteer and a.volunteer.send(condition) and !a.cancelled
          accepted += 1 if wa.accepted
          asked += 1 if wa.state == :asked
        end
      end

      wc.send("accepted_places#{sufix}=", accepted)
      wc.send("asked_for_places#{sufix}=", asked)
    end

    wc.free_places = wc.places - wc.accepted_places
    wc.free_places_for_males = [ wc.free_places, wc.places_for_males - wc.accepted_places_males ].min
    wc.free_places_for_females = [ wc.free_places, wc.places_for_females - wc.accepted_places_females ].min

    # wc.update_attribute("free_places", wc.places - wc.accepted_places)
    # wc.update_attribute("free_places_for_males",
    #                     [ wc.free_places, wc.places_for_males - wc.accepted_places_males ].min)
    # wc.update_attribute("free_places_for_females",
    #                     [ wc.free_places, wc.places_for_females - wc.accepted_places_females ].min)
  end


end
