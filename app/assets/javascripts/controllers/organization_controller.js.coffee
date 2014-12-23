Volant.OrganizationController = Ember.ObjectController.extend
  needs: ['application']
  year: Ember.computed.alias('controllers.application.year')
