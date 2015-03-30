module FreePlacesUpdater
  extend ActiveSupport::Concern

  def update_free_places
    if self.respond_to?(:workcamps)
      self.workcamps.reload.each { |wc| wc.save(validate: false) }
    elsif self.respond_to?(:workcamp)
      self.workcamp.save(validate: false)
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
      capacity = asked = accepted = 0

      wc.workcamp_assignments.each do |wa|
        form = wa.apply_form
        next if form.cancelled
        next unless form.send(condition)

        case form
        when Incoming::ApplyForm
          capacity += 1 if wa.accepted
        else
          accepted += 1 if wa.accepted
          asked += 1 if wa.state == :asked
        end
      end

      wc.send("accepted_places#{sufix}=", accepted)
      wc.send("asked_for_places#{sufix}=", asked)
      wc.send("accepted_incoming_places#{sufix}=", capacity)
    end

    wc.free_capacity = wc.capacity - wc.accepted_incoming_places
    wc.free_capacity_males = [ wc.free_capacity, wc.capacity_males - wc.accepted_incoming_places_males ].min
    wc.free_capacity_females = [ wc.free_capacity, wc.capacity_females - wc.accepted_incoming_places_females ].min    

    wc.free_places = wc.places - wc.accepted_places
    wc.free_places_for_males = [ wc.free_places, wc.places_for_males - wc.accepted_places_males ].min
    wc.free_places_for_females = [ wc.free_places, wc.places_for_females - wc.accepted_places_females ].min
  end



end
