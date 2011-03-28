module Outgoing
  module WorkcampsHelper

    def tags_column(wc)
      fee = if wc.extra_fee && wc.extra_fee > 0
              icon('extra_fee', wc.extra_fee.to_i.to_s + ' ' + wc.extra_fee_currency.to_s, false)
            else
              nil
            end

      [ fee, TaggableHelper.render_tags(wc.tags) ].compact * ','
    end

    # FIXME - CHANGE NAME TO apply_forms_column
    # Shows all applications assigned to this workcamp
    def apply_forms_column(wc)
      labels = wc.workcamp_assignments.map do |a|
        name = a.apply_form.volunteer.name

        if a.current? or a.history?
          name_label = name
          state = a.state
        else
          name_label = content_tag(:span, name, { :class => 'disabled' })
          state = :after
        end

        state_label = Outgoing::WorkcampAssignment.human_attribute_name(state)
        [ state, icon( state, state_label, true) + name_label ]
      end

      labels = labels.sort_by do |state, label|
        WorkcampAssignment::STATE_ORDER.index(state)
      end


      labels.map { |l| l[1] }.join('<br/>')
    end

    def free_places_column(record)
      places(nil,record)
    end

    def free_places_for_females_column(record)
      places('females',record)
    end

    def free_places_for_males_column(record)
      places('males',record)
    end

    def places(sufix, record)
      if sufix
        column = "free_places_for_#{sufix}"
        free = record.send( column)
        asked = record.send( "asked_for_places_#{sufix}")
      else
        free = record.free_places
        asked = record.asked_for_places
      end

      "#{free}/#{asked}"
    end


  end
end
