Volant.ApplyFormActionPickerController = Ember.ObjectController.extend Volant.AjaxToStoreMixin,
  actions:
    changeState: ->
      action = @get('action_name')
      form = @get('apply_form')
      url = "/apply_forms/#{form.get('id')}/#{action}"
      @ajax_to_store(url).then ((payload) =>
        @flash_info 'State changed'), (err) =>
        console.error err
        @flash_error 'Failed.'
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
