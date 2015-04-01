Volant.OrganizationsSelectController = Ember.ArrayController.extend
  sortProperties: ['name']
  sortAscending: true

  content: (->
    @store.find('organization')
  ).property()
