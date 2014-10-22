Volant.WorkcampController = Volant.ObjectController.extend {
  needs: ['countries','workcamp_intentions','organizations','tags']
  # isDirty: Ember.computed.any('model.isDirty','changed')
  # changed: false

  # organization_change: (->
  #   @set('changed',true)
  # ).observes('organization')

}
