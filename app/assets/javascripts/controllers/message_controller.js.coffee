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
    @get('model').save().then (-> @send('removeModal')), (-> console.info 'ouch')
})
