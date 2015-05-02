Volant.ApplyFormActionPickerController = Ember.ObjectController.extend Volant.Flash, Volant.AjaxToStoreMixin,
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
      @transitionToRoute('new_message',apply_form.get('id'),action_name)

      @send 'closeModal'
