Volant.MessageController = Volant.ObjectController.extend({
  needs: 'email_templates'
  from_field_editable: false

  after_save_route: 'apply_forms'

  actions:
    edit_from_field: ->
      @toggleProperty('from_field_editable')
})
