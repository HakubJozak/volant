Volant.ImportedWorkcampsController = Ember.ArrayController.extend
  sortProperties: ['createdAt']
  needs: ['application','pagination']
  mode: Ember.computed.alias('controllers.application.mode')
  messages: []

  

