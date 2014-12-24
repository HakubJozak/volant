Volant.ApplyFormActions = Ember.Mixin.create

  actions:
    closeModal: ->
      @disconnectOutlet 'modal'

    apply_form_action: (action,form) ->
      switch action
        when 'pay'
          @controllerFor('apply_form').set('anchor','payment-fields')

        when 'cancel'
          url = "/apply_forms/#{form.get('id')}/cancel"
          @ajax_to_store(url).then (payload) =>
            @flash_info 'Application cancelled.'
        else
          @render 'apply_form/action_dialog',outlet: 'modal'
#          @openMessageFor(action,form)


  openMessageFor: (action_name,apply_form) ->
    @store.find('user',@get('current_user.content.id')).then (user) =>
      apply_form.get('current_workcamp').then (workcamp) =>
        message = @store.createRecord 'message', {
          action: action_name
          apply_form: apply_form
          user: user
        }

        @transitionTo('message',message)

    false
