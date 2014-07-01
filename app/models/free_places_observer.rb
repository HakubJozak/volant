# TODO - move to Outgoing module
class FreePlacesObserver < ActiveRecord::Observer
  observe Outgoing::WorkcampAssignment, Outgoing::ApplyForm

  def after_save(object)
    if object.respond_to?(:workcamps)
      object.workcamps.reload.each { |wc| FreePlacesObserver.update_free_places(wc) }
    else
      FreePlacesObserver.update_free_places(object.workcamp)
    end
  end

  def after_destroy(object)
    after_save(object)
  end


  # In fact, updates accepted_* and asked_for_* attributes so that free_places_* are computed correctly.
  def self.update_free_places(wc)
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
  end

  
end
