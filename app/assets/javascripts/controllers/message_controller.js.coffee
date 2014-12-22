Volant.MessageController = Volant.ObjectController.extend({
  needs: [ 'email_templates' ]
  after_save_route: 'messages'
  editable: Ember.computed.not('delivered')

  emailTemplate: null

})
