Volant.OrganizationController = Ember.ObjectController.extend
  needs: ['application','countries','email_contacts']
  year: Ember.computed.alias('controllers.application.year')
