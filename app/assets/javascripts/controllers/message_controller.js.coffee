Volant.MessageController = Volant.ObjectController.extend
  needs: [ 'email_templates' ]
  editable: Ember.computed.not('delivered')
  selectedTemplate: null

  workcamp: (->
    @get('model.workcamp') || @get('applyForm.currentWorkcamp')
  ).property('model.workcamp','applyForm.currentWorkcamp')

  actions:
    useSelectedTemplate: ->
      if tmpl = @get('selectedTemplate')
        if confirm 'All the changes you made will be wiped out. Are you sure?'
          @send 'useTemplate',tmpl
      false
