Volant.OrganizationController = Ember.ObjectController.extend
  needs: ['application','countries','email_contacts','networks']
  year: Ember.computed.alias('controllers.application.year')
