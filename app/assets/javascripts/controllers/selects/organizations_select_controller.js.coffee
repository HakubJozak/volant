Volant.OrganizationsSelectController = Ember.ArrayController.extend
  sortProperties: ['name']
  sortAscending: true

  model: (->
    @store.find('organization')
  ).property()
