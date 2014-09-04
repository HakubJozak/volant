module Outgoing::FreePlacesUpdater
  extend ActiveSupport::Concern

  included do
    after_save :update_free_places
    after_destroy :update_free_places
  end

  def update_free_places
    if self.respond_to?(:workcamps)
      self.workcamps.reload.each { |wc| update_free_places_for_workcamp(wc) }
    elsif self.respond_to?(:workcamp)
      update_free_places_for_workcamp(self.workcamp)
    else
      raise "Cannot update free places. #{self.inspect} has no workcamp(s) association."
    end
  end

  private

  # In fact, updates accepted_* and asked_for_* attributes so that free_places_* are computed correctly.
  def update_free_places_for_workcamp(wc)
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

      wc.update_attribute("accepted_places#{sufix}", accepted)
      wc.update_attribute("asked_for_places#{sufix}", asked)
    end

    wc.update_attribute("free_places", wc.places - wc.accepted_places)
    wc.update_attribute("free_places_for_males",
                        [ wc.free_places, wc.places_for_males - wc.accepted_places_males ].min)
    wc.update_attribute("free_places_for_females",
                        [ wc.free_places, wc.places_for_females - wc.accepted_places_females ].min)
  end


end
