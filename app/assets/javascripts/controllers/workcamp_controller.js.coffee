Volant.WorkcampController = Ember.ObjectController.extend({
  actions:
    save: ->
      @get('model').save()
})
