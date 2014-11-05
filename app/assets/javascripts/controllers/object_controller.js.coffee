Volant.ObjectController = Ember.ObjectController.extend({
  actions:
    toggle_starred: ->
      @toggleProperty('starred')
      @send('save')
      false
})
