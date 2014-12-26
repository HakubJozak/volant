Volant.OrganizationController = Ember.ObjectController.extend
  needs: ['application','countries']
  year: Ember.computed.alias('controllers.application.year')
