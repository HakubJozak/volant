Volant.WorkcampController = Ember.Controller.extend({
  actions:
    save: ->
      @get('model').save()
})
