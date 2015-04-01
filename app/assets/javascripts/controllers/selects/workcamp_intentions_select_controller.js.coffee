Volant.WorkcampIntentionsSelectController = Ember.ArrayController.extend
  sortProperties: ['code']
  sortAscending: true

  model: (->
    @store.find('workcamp_intention')
  ).property()
