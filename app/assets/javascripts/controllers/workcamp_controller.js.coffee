Volant.WorkcampController = Ember.ObjectController.extend {
  needs: ['countries','workcamp_intentions','organizations','tags']

  publish_modes: [ { code: 'NEVER', label: 'Never' }, { code: 'ALWAYS', label: 'Always' }, { code: 'SEASON', label: 'During season' } ]

  # isDirty: Ember.computed.or('model.isDirty','changed')
  #  changed: false
  # association_observer: (->
  #   @set('changed', true)
  # ).observes('model.organization','model.country','model.tags.@each','model.workcamp_intentions.@each')

  imported_or_updated: (->
    s = @get('state')
    s == 'imported' || s == 'updated'
  ).property('state')


  set_country: (->
    unless @get('country')
      if @get('organization')
        @set('country', @get('organization.country'))
  ).observes('organization')
}
