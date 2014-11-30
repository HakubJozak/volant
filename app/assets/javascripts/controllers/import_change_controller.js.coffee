Volant.ImportChangeController = Ember.ObjectController.extend({
  actions:
    apply: ->
      @get('model').apply()
      @get('model').destroyRecord().then (->
        console.info 'import change applied and deleted'
      )

    remove: ->
      @get('model').destroyRecord().then (->
        console.info 'import change deleted'
      )
})
