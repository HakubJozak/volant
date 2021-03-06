Volant.EmailContactsController = Ember.ArrayController.extend
  needs: 'organization'
  actions:
    add: ->
      org = @get('controllers.organization.model')
      email = @store.createRecord('email_contact', { organization: org } )
      @get('model').unshiftObject(email)
      false

    remove: (contact) ->
      if contact.get('isNew')
        @get('model').removeObject(contact)
      else
        contact.destroyRecord()
      false
