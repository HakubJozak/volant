Volant.ApplyFormActions = Ember.Mixin.create

  actions:
    pay: ->
      @controllerFor('apply_form').set('anchor','payment-fields')

    apply_form_action: (action,form) ->
      switch action
        when 'pay'
          @send 'pay',form

        when 'email'
          console.info 'emailing'

        when 'cancel'
          url = "/apply_forms/#{form.get('id')}/cancel"
          @ajax_to_store(url).then (payload) =>
            @flash_info 'Application cancelled.'
        else
          model = Ember.Object.create { action_name: action, apply_form: form }
          @render 'apply_form/action_picker',outlet: 'modal', controller: 'apply_form_action_picker', model: model
