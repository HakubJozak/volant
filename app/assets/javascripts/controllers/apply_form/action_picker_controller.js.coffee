Volant.ApplyFormActionPickerController = Ember.ObjectController.extend
  actions:
    changeAssignment: ->
      @get('apply_form.current_assignment').then (wa) ->
        console.info 'changing', wa
      @send 'closeModal'

    openMessage: ->
      action_name = @get('action_name')
      apply_form = @get('apply_form')

      @store.find('user',@get('current_user.content.id')).then (user) =>
        apply_form.get('current_workcamp').then (workcamp) =>
          message = @store.createRecord 'message', {
            action: action_name
            apply_form: apply_form
            user: user
          }

          @transitionToRoute('message',message)

      @send 'closeModal'
