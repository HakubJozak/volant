Volant.WorkcampController = Ember.ObjectController.extend {
  needs: ['countries','workcamp_intentions','organizations','tags']
  # isDirty: Ember.computed.any('model.isDirty','changed')
  # changed: false

  # organization_change: (->
  #   @set('changed',true)
  # ).observes('organization')
  publish_modes: [ { id: 'NEVER', label: 'Never' }, { id: 'ALWAYS', label: 'Always' }, { id: 'SEASON', label: 'During season' } ]

  set_country: (->
    unless @get('country')
      if @get('organization')
        @set('country', @get('organization.country'))
  ).observes('organization')
}
