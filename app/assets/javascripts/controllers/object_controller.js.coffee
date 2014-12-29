Volant.ObjectController = Ember.ObjectController.extend
  genders: [ { code: 'm', name: 'Male' }, { code: 'f', name: 'Female'}]

  isWorkcamp: (->
    @get('model').constructor.typeKey == 'workcamp'
  ).property()
