Volant.TagsSelectController = Ember.ArrayController.extend
  sortProperties: ['name']
  sortAscending: true

  model: (->
    @store.find('tag')
  ).property()
