Volant.EmailContactController = Ember.ObjectController.extend({
  edited: false
  kinds: [
    {label: "Outgoing",  id: 'OUTGOING'},
    {label: "Incoming",  id: 'INCOMING'},
    {label: "Don't use", id: ''}
   ]

  actions:
    edit: ->
      @set('edited', true)

    save: ->
      console.info 'saving'
      @get('model').save().then(
        (record) => @set('edited', false),
        (error)  -> console.error 'failed to save the email contact'
      )

    rollback: ->
      @get('model').rollback()
      @set('edited', false)
})
