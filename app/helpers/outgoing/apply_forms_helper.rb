module Outgoing
  module ApplyFormsHelper
    ApplicationHelper::date_fields :created_at, :rejected, :cancelled, :infosheeted

    def volunteer_tags_column(form)
      vols = '' || TaggableHelper.render_tags(form.volunteer.tags) if form.volunteer
      vols.to_s + TaggableHelper.render_tags(form.tags)
    end

    def workcamp_tags_column(form)
      tags_column(form.current_workcamp) if form.current_workcamp
    end

    # def list_row_class(form)
    #   clazz = ''

    #   if form and form.current_workcamp
    #     # clazz << 'alert ' if form.has_alerts?

    #     if form.is?(:paid) or form.is?(:asked)
    #       if form.current_workcamp.full?(form.volunteer)
    #         clazz.concat('full')
    #       elsif form.current_workcamp.almost_full?(form.volunteer)
    #         clazz.concat('almost_full')
    #       else
    #         clazz << 'empty'
    #       end
    #     end
    #   end

    #   clazz
    # end

    def actions_column(record)
      if record.current_workcamp
        record.actions.map do |action|
          #label = I18n.translate("model.apply_form_actions.#{action}")
          label = ApplyForm.human_attribute_name("apply_form_actions.#{action}")
          label = icon(action.to_s, label, true)
          # TODO - from routes
          url = url_for :overwrite_params => { :action => action, :id => record.id, '_method' => 'get' }
          link_to label, url, :position => "after", :class => "action"
        end.join(' ')
      end
    end

    def state_column(record)
      state = record.state

      bubble_id = "state-bubble-#{record.id}"
      link_id = "link-state-bubble-#{record.id}"

      b = bubble bubble_id, icon(state.name, state.info)
      i = icon(state.name, state.to_label)
      l = link_to_function(i, "show_bubble('#{bubble_id}','#{link_id}')", :id => link_id)

      # TODO - use tooltip from the LivePipe UI
      script = javascript_tag %{
//        var tooltip = new Control.ToolTip($('#{link_id}'),'#{i}',{
//                          className: 'tooltip'
//        });

       $('body').observe('click', function(event) { hide_bubble('#{bubble_id}');  });
     }

      b + l + script
    end

    def volunteer_form_column(record, input_name)
      belongs_to_auto_completer_as :volunteer, :name
    end

    def current_workcamp_column(record)
      return '-' unless wc = record.current_workcamp
      link_to wc.to_label, edit_outgoing_workcamp_path(wc, :parent_controller => 'outgoing/apply_forms'),
      :class => "edit action volunteer",
      :position => "after"
    end

    def current_workcamp_places_for_males_column(form)
      free_places_for_males_column(form.current_workcamp) if form.current_workcamp
    end

    def current_workcamp_places_for_females_column(form)
      free_places_for_females_column(form.current_workcamp) if form.current_workcamp
    end

    def current_workcamp_places_column(form)
      free_places_column(form.current_workcamp) if form.current_workcamp
    end

    def volunteer_column(record)
      volunteer_label(record.volunteer) if record.volunteer
    end

    def volunteer_age_column(record)
      record.volunteer.age if record.volunteer
    end

    def empty_volunteer_column
      icon('assign_volunteer',I18n.translate('model.create_volunteer'))
    end

    def payment_column(record)
      volant_number_to_currency(record.payment.amount) if record.payment
    end

    # def empty_payment_column
    #   icon('create_payment', I18n.translate('model.create_payment'))
    # end

    def as_field(label, inside)
      label = label ? t(label) : ''
      locals = { :label => label, :inside => inside }
      render :partial => 'shared/as_field', :locals => locals
    end

    # TODO - URL from routes...
    def state_change_url(action, id)
      "/#{@controller.controller_path}/#{action}/#{id}"
    end


    def alerts_column(record)
      result = ''
      result << alert('waits_too_long') if record.waits_too_long?
      result << alert('no_infosheet') if record.no_infosheet?
      result
    end

    protected

    def alert(type)
      icon(type, I18n.translate("model.apply_form_alerts.#{type}"), true)
    end


  end
end
