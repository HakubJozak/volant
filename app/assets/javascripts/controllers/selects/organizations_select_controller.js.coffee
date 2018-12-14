Volant.OrganizationsSelectController = Ember.ArrayController.extend
  sortProperties: ['name']
  sortAscending: true

  filterByCountry: (country_id) ->
    if country_id?
      filtered = @store.filter('organization',{ country_id: country_id },(org) => org.get('country.id') == country_id)
      @set 'model', filtered
    else
      @set 'model', @store.filter('organization',{},(org) => true)

  model: (->
    @store.find('organization')
  ).property()
