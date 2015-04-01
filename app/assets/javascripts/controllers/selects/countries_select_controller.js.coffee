Volant.CountriesSelectController = Ember.ArrayController.extend
  sortProperties: ['name']
  sortAscending: true

  model: (->
    @store.find('country')
  ).property()
