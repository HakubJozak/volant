Volant.MessageController = Ember.ObjectController.extend({
  needs: 'email_templates'
  from_field_editable: false

  actions:
    edit_from_field: ->
      @toggleProperty('from_field_editable')

    send: ->
      @set('model.deliver_on_save',true)
      @save_model()

    close_and_save: ->
      @set('model.deliver_on_save',false)
      @save_model()

  save_model: ->
    @store.scheduleSave(this.get('model'))
    @store.scheduleSave(this.get('model.apply_form'))
    @store.commit().then (=>
      @send('removeModal')
    ), ( (err) =>
      console.error err
    )
})
