Volant.MessageController = Ember.ObjectController.extend({
  actions:
    close: ->
      @send('closeModal')
})
