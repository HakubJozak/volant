Volant.WorkcampController = Ember.ObjectController.extend {
  needs: ['countries','workcamp_intentions','organizations','tags']
  # isDirty: Ember.computed.any('model.isDirty','changed')
  # changed: false

  publish_modes: [ { code: 'NEVER', label: 'Never' }, { code: 'ALWAYS', label: 'Always' }, { code: 'SEASON', label: 'During season' } ]

  set_country: (->
    unless @get('country')
      if @get('organization')
        @set('country', @get('organization.country'))
  ).observes('organization')
}
