Volant.EmailContactsController = Ember.ArrayController.extend({
  actions:
    add: ->
    remove: (contact) ->
      console.info 'removing' + contact.get('address')
      contact.destroyRecord()
      # contact.deleteRecord()
      # contact.save()
})
