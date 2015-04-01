Volant.OrganizationController = Ember.ObjectController.extend
  needs: ['application','countriesSelect','email_contacts','networks']
  year: Ember.computed.alias('controllers.application.year')
