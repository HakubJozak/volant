Volant.MessageController = Ember.ObjectController.extend({
  needs: 'email_templates'
  from_field_editable: false

  actions:
    edit_from_field: ->
      @toggleProperty('from_field_editable')

    save: ->
      @get('content').save().then (=>
        @send('removeModal')
      ), ( (err) =>
        console.error err
      )
})
