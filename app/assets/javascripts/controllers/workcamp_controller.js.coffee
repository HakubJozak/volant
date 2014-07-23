Volant.WorkcampController = Ember.ObjectController.extend({
  actions:
    save: ->
      @get('model').save().then (->
        console.info 'success'), ->
        console.info 'error'
})
