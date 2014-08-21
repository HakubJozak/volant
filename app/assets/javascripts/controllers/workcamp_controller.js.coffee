Volant.WorkcampController = Ember.ObjectController.extend({
  flash: null
  starred: false

  actions:
    toggle_starred: ->
      @toggleProperty('starred')

    save: ->
      SUCCESS = =>
        @set('flash', { type: 'success', message: 'Workcamp saved succesfully.' })

      ERROR = =>
        @set('flash', { type: 'error', message: 'Failed to save the workcamp.' })

      @get('model').save().then(SUCCESS,ERROR)

    cancel: ->
      @get('model').rollback()

})
