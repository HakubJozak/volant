Volant.MessageController = Ember.ObjectController.extend({
  needs: 'email_templates'

  actions:
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
