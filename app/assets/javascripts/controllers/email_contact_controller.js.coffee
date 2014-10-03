Volant.EmailContactController = Ember.ObjectController.extend({
  edited: false

  actions:
    edit: ->
      @set('edited', true)

    save: ->
      console.info 'saving'
      @get('model').save().then (=>
        console.info 'stuff'
        @set('edited', false)), (r) ->
        console.info 'errorish'

    rollback: ->
      @get('model').rollback()
      @set('edited', false)
})
