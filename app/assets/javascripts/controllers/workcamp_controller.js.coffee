Volant.WorkcampController = Volant.ObjectController.extend {
  needs: ['countries','workcamp_intentions','organizations','tags']
#  isDirty: (->  ).property('model.isDirty')
#  Ember.computed.any('model.isDirty','model.country_id','model.organization_id')
}
