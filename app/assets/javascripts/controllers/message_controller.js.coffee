Volant.MessageController = Volant.ObjectController.extend
  needs: [ 'email_templates' ]
  after_save_route: 'messages'
  editable: Ember.computed.not('delivered')
  selectedTemplate: null

  actions:
    useSelectedTemplate: ->
      if tmpl = @get('selectedTemplate')
        if confirm 'All the changes you made will be wiped out. Are you sure?'
          @send 'useTemplate',tmpl
      false
