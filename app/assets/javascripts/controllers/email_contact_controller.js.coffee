Volant.EmailContactController = Ember.ObjectController.extend({
  needs: 'email_contacts'
  edited: false
  edited_or_new: Ember.computed.or('edited','isNew')

  kinds: [
    {label: "Outgoing",  id: 'OUTGOING'},
    {label: "Incoming",  id: 'INCOMING'},
    {label: "Don't use", id: ''}
   ]

  actions:
    edit: ->
      @set('edited', true)

    save: ->
      @get('model').save().then(
        (record) => @set('edited', false),
        (error)  -> console.error 'failed to save the email contact'
      )

    rollback: ->
      @get('model').rollback()
      @set('edited', false)
})
